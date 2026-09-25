import React, { createContext, useContext, useState, useEffect, useMemo } from "react";
import {
  HierarchyNode,
  Worker,
  SOSAlert,
  BulkRequest,
  RateCard,
  AuditEvent,
  NotificationItem,
  DemoAccount,
  HierarchyTier,
  BlueCollarTrade,
  FederationBasePrice,
  SocietyServiceTaskPrice,
  AreaServiceDemandAvailability,
} from "../types";
import {
  initialHierarchyNodes,
  initialWorkers,
  initialSOSAlerts,
  initialBulkRequests,
  initialRateCards,
  initialAuditEvents,
  initialNotifications,
  demoAccounts,
  initialFederationBasePrices,
  initialSocietyTaskPrices,
  initialAreaDemandAvailability,
} from "../data/mockData";

interface AppContextType {
  currentAccount: DemoAccount | null;
  currentNode: HierarchyNode | null;
  breadcrumbTrail: Array<{ label: string; tier: string; code: string }>;
  
  // Role Helpers
  isFederation: boolean;
  isSociety: boolean;
  switchRole: (role: "federation" | "society") => void;

  // Scoped Data
  allHierarchyNodes: HierarchyNode[];
  scopedManagedNodes: HierarchyNode[]; // Direct children managed by this tier
  scopedSocieties: HierarchyNode[];
  scopedWorkers: Worker[];
  scopedSOSAlerts: SOSAlert[];
  scopedBulkRequests: BulkRequest[];
  rateCards: RateCard[];
  auditEvents: AuditEvent[];
  notifications: NotificationItem[];
  
  // Federation Base Prices (Statutory Bands)
  federationBasePrices: FederationBasePrice[];
  updateFederationBasePrice: (
    id: string,
    updates: {
      baseHourlyRate: number;
      minFloorRate: number;
      maxCeilingRate: number;
      recommendedVisitCharge: number;
      complianceNotes?: string;
    }
  ) => void;

  // Society Granular Task Pricing (Tap replacement, shower change, etc.)
  societyTaskPrices: SocietyServiceTaskPrice[];
  scopedSocietyTaskPrices: SocietyServiceTaskPrice[];
  updateSocietyTaskPrice: (id: string, newPrice: number) => void;
  addSocietyTaskPrice: (task: Omit<SocietyServiceTaskPrice, "id" | "updatedAt">) => void;

  // Area-wise Demand & Availability
  areaDemandData: AreaServiceDemandAvailability[];
  rebalanceAreaWorkers: (areaId: string, trade: BlueCollarTrade, countToAdd: number) => void;

  // Forecast Readiness state
  isForecastReadinessPassed: boolean;
  toggleDemandReadiness: (passed?: boolean) => void;
  
  // Actions
  login: (accountId: string) => void;
  logout: () => void;
  
  addChildNode: (data: {
    name: string;
    contactPerson: string;
    contactPhone: string;
    region: string;
  }) => void;
  
  addWorker: (data: {
    name: string;
    trade: BlueCollarTrade;
    specialization?: string;
    phone: string;
    experienceYears: number;
    locationCluster: string;
  }) => void;
  
  dispatchSOS: (alertId: string, workerId: string) => void;
  resolveSOS: (alertId: string) => void;
  
  proposeBulkTeam: (requestId: string, workerIds: string[]) => void;
  confirmBulkRequest: (requestId: string) => void;
  
  addRateCard: (card: Omit<RateCard, "id" | "lastUpdated">) => void;
  toggleRateCardStatus: (cardId: string) => void;
  updateRateCardRate: (cardId: string, newRate: number) => void;
  
  markNotificationRead: (id: string) => void;
  markAllNotificationsRead: () => void;
  
  searchGlobal: (query: string) => {
    workers: Worker[];
    societies: HierarchyNode[];
    bulkRequests: BulkRequest[];
    sosAlerts: SOSAlert[];
    taskPrices: SocietyServiceTaskPrice[];
  };
}

const AppContext = createContext<AppContextType | undefined>(undefined);

const STORAGE_KEY_ACCOUNT = "skillskart_active_account_id_v10";
const STORAGE_KEY_NODES = "skillskart_nodes_v10";
const STORAGE_KEY_WORKERS = "skillskart_workers_v10";
const STORAGE_KEY_ALERTS = "skillskart_alerts_v10";
const STORAGE_KEY_BULK = "skillskart_bulk_v10";
const STORAGE_KEY_RATES = "skillskart_rates_v10";
const STORAGE_KEY_AUDIT = "skillskart_audit_v10";
const STORAGE_KEY_BASE_PRICES = "skillskart_base_prices_v10";
const STORAGE_KEY_TASK_PRICES = "skillskart_task_prices_v10";
const STORAGE_KEY_AREA_DEMAND = "skillskart_area_demand_v10";

export const AppProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [currentAccount, setCurrentAccount] = useState<DemoAccount | null>(() => {
    const saved = localStorage.getItem(STORAGE_KEY_ACCOUNT);
    if (saved) {
      const found = demoAccounts.find((a) => a.id === saved);
      if (found) return found;
    }
    return null; // Start at login by default
  });

  const [nodes, setNodes] = useState<HierarchyNode[]>(() => {
    const saved = localStorage.getItem(STORAGE_KEY_NODES);
    return saved ? JSON.parse(saved) : initialHierarchyNodes;
  });

  const [workers, setWorkers] = useState<Worker[]>(() => {
    const saved = localStorage.getItem(STORAGE_KEY_WORKERS);
    return saved ? JSON.parse(saved) : initialWorkers;
  });

  const [alerts, setAlerts] = useState<SOSAlert[]>(() => {
    const saved = localStorage.getItem(STORAGE_KEY_ALERTS);
    return saved ? JSON.parse(saved) : initialSOSAlerts;
  });

  const [bulkRequests, setBulkRequests] = useState<BulkRequest[]>(() => {
    const saved = localStorage.getItem(STORAGE_KEY_BULK);
    return saved ? JSON.parse(saved) : initialBulkRequests;
  });

  const [rateCards, setRateCards] = useState<RateCard[]>(() => {
    const saved = localStorage.getItem(STORAGE_KEY_RATES);
    return saved ? JSON.parse(saved) : initialRateCards;
  });

  const [auditEvents, setAuditEvents] = useState<AuditEvent[]>(() => {
    const saved = localStorage.getItem(STORAGE_KEY_AUDIT);
    return saved ? JSON.parse(saved) : initialAuditEvents;
  });

  const [federationBasePrices, setFederationBasePrices] = useState<FederationBasePrice[]>(() => {
    const saved = localStorage.getItem(STORAGE_KEY_BASE_PRICES);
    return saved ? JSON.parse(saved) : initialFederationBasePrices;
  });

  const [societyTaskPrices, setSocietyTaskPrices] = useState<SocietyServiceTaskPrice[]>(() => {
    const saved = localStorage.getItem(STORAGE_KEY_TASK_PRICES);
    return saved ? JSON.parse(saved) : initialSocietyTaskPrices;
  });

  const [areaDemandData, setAreaDemandData] = useState<AreaServiceDemandAvailability[]>(() => {
    const saved = localStorage.getItem(STORAGE_KEY_AREA_DEMAND);
    return saved ? JSON.parse(saved) : initialAreaDemandAvailability;
  });

  const [notifications, setNotifications] = useState<NotificationItem[]>(initialNotifications);
  const [isForecastReadinessPassed, setIsForecastReadinessPassed] = useState<boolean>(true);

  // Sync to localStorage
  useEffect(() => {
    if (currentAccount) {
      localStorage.setItem(STORAGE_KEY_ACCOUNT, currentAccount.id);
    } else {
      localStorage.removeItem(STORAGE_KEY_ACCOUNT);
    }
  }, [currentAccount]);

  useEffect(() => {
    localStorage.setItem(STORAGE_KEY_NODES, JSON.stringify(nodes));
  }, [nodes]);

  useEffect(() => {
    localStorage.setItem(STORAGE_KEY_WORKERS, JSON.stringify(workers));
  }, [workers]);

  useEffect(() => {
    localStorage.setItem(STORAGE_KEY_ALERTS, JSON.stringify(alerts));
  }, [alerts]);

  useEffect(() => {
    localStorage.setItem(STORAGE_KEY_BULK, JSON.stringify(bulkRequests));
  }, [bulkRequests]);

  useEffect(() => {
    localStorage.setItem(STORAGE_KEY_RATES, JSON.stringify(rateCards));
  }, [rateCards]);

  useEffect(() => {
    localStorage.setItem(STORAGE_KEY_AUDIT, JSON.stringify(auditEvents));
  }, [auditEvents]);

  useEffect(() => {
    localStorage.setItem(STORAGE_KEY_BASE_PRICES, JSON.stringify(federationBasePrices));
  }, [federationBasePrices]);

  useEffect(() => {
    localStorage.setItem(STORAGE_KEY_TASK_PRICES, JSON.stringify(societyTaskPrices));
  }, [societyTaskPrices]);

  useEffect(() => {
    localStorage.setItem(STORAGE_KEY_AREA_DEMAND, JSON.stringify(areaDemandData));
  }, [areaDemandData]);

  // Current Hierarchy Node
  const currentNode = useMemo(() => {
    if (!currentAccount) return null;
    const found = nodes.find((n) => n.id === currentAccount.nodeId);
    if (found) return found;
    return initialHierarchyNodes.find((n) => n.id === currentAccount.nodeId) || null;
  }, [currentAccount, nodes]);

  // Role Helpers
  const isFederation = currentAccount?.roleType === "federation" || currentNode?.tier === "federation";
  const isSociety = currentAccount?.roleType === "society" || currentNode?.tier === "society";

  const switchRole = (role: "federation" | "society") => {
    const acc = demoAccounts.find((a) => a.roleType === role) || demoAccounts[0];
    if (acc) {
      setCurrentAccount(acc);
    }
  };

  // Breadcrumb Trail from Root to Current Node
  const breadcrumbTrail = useMemo(() => {
    if (!currentNode) return [];
    const trail: Array<{ label: string; tier: string; code: string }> = [];
    let curr: HierarchyNode | undefined = currentNode;

    while (curr) {
      trail.unshift({
        label: curr.name,
        tier: curr.tier.toUpperCase(),
        code: curr.code,
      });
      if (curr.parentId) {
        curr = nodes.find((n) => n.id === curr!.parentId);
      } else {
        break;
      }
    }
    return trail;
  }, [currentNode, nodes]);

  // Hierarchical Data Scoping
  // 1. Direct children managed by this tier (National -> Federations, Federation -> Societies, Society -> None/Workers)
  const scopedManagedNodes = useMemo(() => {
    if (!currentNode) return [];
    return nodes.filter((n) => n.parentId === currentNode.id);
  }, [currentNode, nodes]);

  // 2. Societies under current node
  const scopedSocieties = useMemo(() => {
    if (!currentNode) {
      if (currentAccount?.roleType === "federation") {
        return nodes.filter((n) => n.tier === "society" && n.parentId === "fed-mh");
      }
      return nodes.filter((n) => n.id === "soc-plumbers-pune");
    }
    if (currentNode.tier === "national") {
      return nodes.filter((n) => n.tier === "society");
    }
    if (currentNode.tier === "federation") {
      const list = nodes.filter((n) => n.tier === "society" && n.parentId === currentNode.id);
      return list.length > 0 ? list : initialHierarchyNodes.filter((n) => n.tier === "society" && n.parentId === "fed-mh");
    }
    if (currentNode.tier === "society") {
      return [currentNode];
    }
    return [];
  }, [currentNode, currentAccount, nodes]);

  // 3. Workers under current node
  const scopedWorkers = useMemo(() => {
    const socIds = scopedSocieties.map((s) => s.id);
    let list = workers.filter((w) => socIds.includes(w.societyId));
    if (list.length === 0) {
      if (currentAccount?.roleType === "society" || currentNode?.tier === "society") {
        list = workers.filter((w) => w.societyId === "soc-plumbers-pune");
        if (list.length === 0) {
          list = initialWorkers.filter((w) => w.societyId === "soc-plumbers-pune");
        }
      } else if (currentAccount?.roleType === "federation" || currentNode?.tier === "federation") {
        list = workers.filter((w) => w.state === "Maharashtra");
        if (list.length === 0) {
          list = initialWorkers;
        }
      }
    }
    return list;
  }, [currentNode, currentAccount, scopedSocieties, workers]);

  // 4. SOS Alerts in current jurisdiction
  const scopedSOSAlerts = useMemo(() => {
    if (!currentNode) return [];
    if (currentNode.tier === "national") return alerts;
    if (currentNode.tier === "federation") {
      return alerts.filter(
        (a) => a.state.toLowerCase() === (currentNode.stateName || "maharashtra").toLowerCase()
      );
    }
    if (currentNode.tier === "society") {
      return alerts.filter((a) => a.societyId === currentNode.id);
    }
    return alerts;
  }, [currentNode, alerts]);

  // 5. Bulk Requests in current jurisdiction
  const scopedBulkRequests = useMemo(() => {
    if (!currentNode) return [];
    if (currentNode.tier === "national") return bulkRequests;
    if (currentNode.tier === "federation") {
      return bulkRequests.filter(
        (b) => b.state.toLowerCase() === (currentNode.stateName || "maharashtra").toLowerCase()
      );
    }
    if (currentNode.tier === "society") {
      return bulkRequests.filter((b) => b.societyId === currentNode.id);
    }
    return bulkRequests;
  }, [currentNode, bulkRequests]);

  // 6. Society Task Prices under current node
  const scopedSocietyTaskPrices = useMemo(() => {
    if (!currentNode) return societyTaskPrices;
    if (currentNode.tier === "society") {
      return societyTaskPrices.filter((stp) => stp.societyId === currentNode.id);
    }
    return societyTaskPrices;
  }, [currentNode, societyTaskPrices]);

  // Helper for recording audit events
  const recordAudit = (
    actionType: AuditEvent["actionType"],
    summary: string,
    details: string,
    beforeValue?: string,
    afterValue?: string
  ) => {
    const newEvent: AuditEvent = {
      id: `aud-${Date.now().toString().slice(-4)}`,
      timestamp: new Date().toISOString().replace("T", " ").slice(0, 19),
      actorName: currentAccount ? currentAccount.officerName : "System Administrator",
      actorTier: currentAccount ? currentAccount.tier : "national",
      actionType,
      summary,
      details,
      beforeValue,
      afterValue,
    };
    setAuditEvents((prev) => [newEvent, ...prev]);
  };

  // Actions
  const login = (accountId: string) => {
    const acc = demoAccounts.find((a) => a.id === accountId);
    if (acc) {
      setCurrentAccount(acc);
    }
  };

  const logout = () => {
    setCurrentAccount(null);
  };

  // Add child node: National adds State, State adds District, District adds Society
  const addChildNode = (data: {
    name: string;
    contactPerson: string;
    contactPhone: string;
    region: string;
  }) => {
    if (!currentNode) return;

    let targetTier: HierarchyTier = "society";
    let codePrefix = "SOC";
    if (currentNode.tier === "national") {
      targetTier = "federation";
      codePrefix = "FED";
    } else if (currentNode.tier === "federation") {
      targetTier = "society";
      codePrefix = "SOC";
    }

    const randomDigits = Math.floor(100 + Math.random() * 900);
    const newCode = `${codePrefix}-2026-${randomDigits}`;
    const newNode: HierarchyNode = {
      id: `node-${Date.now()}`,
      tier: targetTier,
      name: data.name,
      code: newCode,
      parentId: currentNode.id,
      contactPerson: data.contactPerson,
      contactPhone: data.contactPhone,
      contactEmail: `${data.contactPerson.toLowerCase().replace(/\s+/g, ".")}@coopgig.gov.in`,
      region: data.region,
      stateName: currentNode.stateName || "Maharashtra",
      districtName: currentNode.districtName || "Pune",
      activeSocietiesCount: targetTier === "society" ? 1 : 0,
      activeWorkersCount: 0,
      establishedYear: 2026,
      status: "Active",
    };

    setNodes((prev) => [...prev, newNode]);

    recordAudit(
      "HIERARCHY_ADD",
      `Created ${targetTier.toUpperCase()} node: ${data.name}`,
      `Appended ${newCode} under parent ${currentNode.name}. Status set directly to Active.`,
      `Managed: ${scopedManagedNodes.length}`,
      `Managed: ${scopedManagedNodes.length + 1}`
    );
  };

  // Society adds a Worker: directly active, no verification queue
  const addWorker = (data: {
    name: string;
    trade: BlueCollarTrade;
    specialization?: string;
    phone: string;
    experienceYears: number;
    locationCluster: string;
  }) => {
    if (!currentNode) return;
    const socId = currentNode.tier === "society" ? currentNode.id : (scopedSocieties[0]?.id || "soc-plumbers-pune");
    const soc = nodes.find((n) => n.id === socId);

    const newWorker: Worker = {
      id: `wrk-${Date.now().toString().slice(-4)}`,
      name: data.name,
      societyId: socId,
      district: soc?.districtName || "Pune",
      state: soc?.stateName || "Maharashtra",
      trade: data.trade,
      specialization: data.specialization || `${data.trade} Technician`,
      experienceYears: data.experienceYears,
      phone: data.phone,
      email: `${data.name.toLowerCase().replace(/\s+/g, ".")}@coopwork.in`,
      status: "Active",
      rating: 5.0,
      jobsCompleted: 0,
      totalEarnings: 0,
      joinedDate: new Date().toISOString().slice(0, 10),
      currentAvailability: "Available",
      locationCluster: data.locationCluster,
      welfareStatus: {
        eShramVerified: true,
        bocwBoardRegistered: true,
        groupInsuranceActive: true,
        insurancePolicyNumber: `NIC-COOP-${Math.floor(10000 + Math.random() * 90000)}`,
      },
    };

    setWorkers((prev) => [newWorker, ...prev]);

    // Update node worker count
    setNodes((prev) =>
      prev.map((n) => (n.id === socId ? { ...n, activeWorkersCount: (n.activeWorkersCount || 0) + 1 } : n))
    );

    recordAudit(
      "HIERARCHY_ADD",
      `Enrolled blue-collar worker: ${data.name} (${data.trade})`,
      `Registered to society ${soc?.name || socId}. Directly assigned Active status with zero onboarding friction.`,
      `Total Workers: ${scopedWorkers.length}`,
      `Total Workers: ${scopedWorkers.length + 1}`
    );
  };

  const dispatchSOS = (alertId: string, workerId: string) => {
    const worker = workers.find((w) => w.id === workerId);
    setAlerts((prev) =>
      prev.map((a) => {
        if (a.id === alertId) {
          return {
            ...a,
            status: "dispatched",
            dispatchedWorkerId: workerId,
            dispatchedWorkerName: worker ? `${worker.name} (${worker.trade})` : "Backup Relief Unit",
            dispatchedTimestamp: "Just now",
          };
        }
        return a;
      })
    );

    recordAudit(
      "SOS_DISPATCH",
      `Dispatched relief worker to SOS Alert #${alertId}`,
      `Assigned ${worker?.name || workerId} for emergency response. Status shifted Open → Dispatched.`,
      "Status: Open",
      "Status: Dispatched"
    );

    // Push notification
    const alert = alerts.find((a) => a.id === alertId);
    setNotifications((prev) => [
      {
        id: `notif-${Date.now()}`,
        type: "sos",
        title: `Dispatch Confirmed: ${alert?.workerName || "Technician"}`,
        message: `${worker?.name || "Technician"} en route to ${alert?.location || "Job site"}.`,
        timestamp: "Just now",
        read: false,
        linkTarget: "/sos",
      },
      ...prev,
    ]);
  };

  const resolveSOS = (alertId: string) => {
    setAlerts((prev) =>
      prev.map((a) => {
        if (a.id === alertId) {
          return {
            ...a,
            status: "resolved",
            resolvedTimestamp: "Just now",
          };
        }
        return a;
      })
    );

    recordAudit(
      "SOS_RESOLVE",
      `Resolved Emergency SOS Alert #${alertId}`,
      `Incident marked safe, verified by site supervisor. Status shifted Dispatched → Resolved.`,
      "Status: Dispatched",
      "Status: Resolved"
    );
  };

  const proposeBulkTeam = (requestId: string, workerIds: string[]) => {
    setBulkRequests((prev) =>
      prev.map((r) => {
        if (r.id === requestId) {
          return {
            ...r,
            status: "team_proposed",
            proposedWorkerIds: workerIds,
          };
        }
        return r;
      })
    );

    recordAudit(
      "BULK_REQUEST_CONFIRM",
      `Proposed team of ${workerIds.length} workers for Bulk Request #${requestId}`,
      `Selected qualified blue-collar technicians from active society pool. Ready for final deployment commit.`,
      "Status: Pending Review",
      "Status: Team Proposed"
    );
  };

  const confirmBulkRequest = (requestId: string) => {
    setBulkRequests((prev) =>
      prev.map((r) => {
        if (r.id === requestId) {
          return {
            ...r,
            status: "confirmed",
          };
        }
        return r;
      })
    );

    recordAudit(
      "BULK_REQUEST_CONFIRM",
      `Confirmed Institutional Tender Deployment #${requestId}`,
      `Tender locked into cooperative operational ledger. Work order issued.`,
      "Status: Team Proposed",
      "Status: Confirmed"
    );

    setNotifications((prev) => [
      {
        id: `notif-${Date.now()}`,
        type: "bulk",
        title: `Tender Deployment Confirmed: #${requestId}`,
        message: `Official work order sealed with municipal/client partner.`,
        timestamp: "Just now",
        read: false,
        linkTarget: "/bulk-requests",
      },
      ...prev,
    ]);
  };

  const addRateCard = (card: Omit<RateCard, "id" | "lastUpdated">) => {
    const newCard: RateCard = {
      ...card,
      id: `rc-${Date.now().toString().slice(-3)}`,
      lastUpdated: new Date().toISOString().slice(0, 10),
    };

    setRateCards((prev) => [newCard, ...prev]);

    recordAudit(
      "RATE_CARD_UPDATE",
      `Created service rate card: ${card.serviceName}`,
      `Base: ₹${card.baseRateHourly}/hr | Overtime: ₹${card.overtimeRateHourly}/hr | Levy: ${card.cooperativeLevyPercent}%`,
      "Cards: " + rateCards.length,
      "Cards: " + (rateCards.length + 1)
    );
  };

  const toggleRateCardStatus = (cardId: string) => {
    let before = "";
    let after = "";
    setRateCards((prev) =>
      prev.map((rc) => {
        if (rc.id === cardId) {
          before = rc.status;
          after = rc.status === "Active" ? "Draft" : "Active";
          return {
            ...rc,
            status: after as "Draft" | "Active",
            lastUpdated: new Date().toISOString().slice(0, 10),
          };
        }
        return rc;
      })
    );

    recordAudit(
      "RATE_CARD_STATUS_TOGGLE",
      `Toggled Rate Card Status #${cardId}`,
      `Rate card publication status changed from ${before} to ${after}.`,
      `Status: ${before}`,
      `Status: ${after}`
    );
  };

  const updateRateCardRate = (cardId: string, newRate: number) => {
    let beforeRate = 0;
    setRateCards((prev) =>
      prev.map((rc) => {
        if (rc.id === cardId) {
          beforeRate = rc.baseRateHourly;
          return {
            ...rc,
            baseRateHourly: newRate,
            lastUpdated: new Date().toISOString().slice(0, 10),
          };
        }
        return rc;
      })
    );

    recordAudit(
      "RATE_CARD_UPDATE",
      `Updated Tariff on Rate Card #${cardId}`,
      `Base hourly rate adjusted to ₹${newRate}/hr.`,
      `Rate: ₹${beforeRate}/hr`,
      `Rate: ₹${newRate}/hr`
    );
  };

  // Federation Base Price Update (Floor, Ceiling, Standard Tariff)
  const updateFederationBasePrice = (
    id: string,
    updates: {
      baseHourlyRate: number;
      minFloorRate: number;
      maxCeilingRate: number;
      recommendedVisitCharge: number;
      complianceNotes?: string;
    }
  ) => {
    let beforeBase = 0;
    let tradeName = "";
    setFederationBasePrices((prev) =>
      prev.map((fbp) => {
        if (fbp.id === id) {
          beforeBase = fbp.baseHourlyRate;
          tradeName = fbp.trade;
          return {
            ...fbp,
            ...updates,
            lastUpdated: new Date().toISOString().slice(0, 10),
            lastUpdatedBy: currentAccount?.officerName || "Federation Controller",
          };
        }
        return fbp;
      })
    );

    recordAudit(
      "FEDERATION_BASE_PRICE_UPDATE",
      `Adjusted statutory base price band for ${tradeName}`,
      `Base: ₹${updates.baseHourlyRate}/hr (Floor: ₹${updates.minFloorRate} · Cap: ₹${updates.maxCeilingRate} · Visit: ₹${updates.recommendedVisitCharge}).`,
      `Base: ₹${beforeBase}/hr`,
      `Base: ₹${updates.baseHourlyRate}/hr`
    );
  };

  // Society Specific Task Price Update (e.g. Tap replacement, shower change)
  const updateSocietyTaskPrice = (id: string, newPrice: number) => {
    let beforePrice = 0;
    let taskName = "";
    setSocietyTaskPrices((prev) =>
      prev.map((stp) => {
        if (stp.id === id) {
          beforePrice = stp.price;
          taskName = stp.taskName;
          return {
            ...stp,
            price: newPrice,
            updatedAt: new Date().toISOString().slice(0, 10),
          };
        }
        return stp;
      })
    );

    recordAudit(
      "SOCIETY_TASK_PRICE_UPDATE",
      `Adjusted specific task price: ${taskName}`,
      `Society rate updated to ₹${newPrice}. Verified compliant with Federation price floor & ceiling band.`,
      `₹${beforePrice}`,
      `₹${newPrice}`
    );
  };

  // Society Add New Task Item
  const addSocietyTaskPrice = (task: Omit<SocietyServiceTaskPrice, "id" | "updatedAt">) => {
    const newTask: SocietyServiceTaskPrice = {
      ...task,
      id: `stp-${Date.now().toString().slice(-4)}`,
      updatedAt: new Date().toISOString().slice(0, 10),
    };

    setSocietyTaskPrices((prev) => [newTask, ...prev]);

    recordAudit(
      "SOCIETY_TASK_PRICE_UPDATE",
      `Registered new society service task: ${task.taskName}`,
      `Rate ₹${task.price} (${task.estimatedDurationMins} mins, ${task.materialCostPolicy}) added to society catalogue.`,
      "-",
      `₹${task.price}`
    );
  };

  // Area Demand-Availability Rebalance / Mobilization
  const rebalanceAreaWorkers = (areaId: string, trade: BlueCollarTrade, countToAdd: number) => {
    setAreaDemandData((prev) =>
      prev.map((item) => {
        if (item.id === areaId || (item.areaName.includes(areaId) && item.trade === trade)) {
          const newAvailable = item.availableWorkers + countToAdd;
          const newDeficit = item.weeklyDemandRequests - newAvailable;
          const newGapStatus: "Deficit" | "Balanced" | "Surplus" =
            newDeficit > 5 ? "Deficit" : newDeficit < -5 ? "Surplus" : "Balanced";
          return {
            ...item,
            availableWorkers: newAvailable,
            deficitCount: Math.max(0, newDeficit),
            gapStatus: newGapStatus,
            urgencyLevel: newGapStatus === "Deficit" ? "Moderate" : "Optimal",
          };
        }
        return item;
      })
    );

    recordAudit(
      "WORKER_DISPATCH_REBALANCE",
      `Mobilized +${countToAdd} technician capacity for ${trade} in area`,
      `Dispatched relief workers from neighboring surplus societies to resolve local shortage.`,
      "-",
      `+${countToAdd} technicians routed`
    );

    setNotifications((prev) => [
      {
        id: `notif-${Date.now()}`,
        type: "demand",
        title: `Dispatch Mobilized: ${trade}`,
        message: `Routed ${countToAdd} certified technicians to balance area deficit.`,
        timestamp: "Just now",
        read: false,
        linkTarget: "/",
      },
      ...prev,
    ]);
  };

  const toggleDemandReadiness = (passed?: boolean) => {
    setIsForecastReadinessPassed((prev) => (passed !== undefined ? passed : !prev));
  };

  const markNotificationRead = (id: string) => {
    setNotifications((prev) => prev.map((n) => (n.id === id ? { ...n, read: true } : n)));
  };

  const markAllNotificationsRead = () => {
    setNotifications((prev) => prev.map((n) => ({ ...n, read: true })));
  };

  const searchGlobal = (query: string) => {
    const q = query.trim().toLowerCase();
    if (!q) {
      return { workers: [], societies: [], bulkRequests: [], sosAlerts: [], taskPrices: [] };
    }

    const matchedWorkers = scopedWorkers.filter(
      (w) =>
        w.name.toLowerCase().includes(q) ||
        w.trade.toLowerCase().includes(q) ||
        w.phone.includes(q) ||
        w.locationCluster.toLowerCase().includes(q) ||
        (w.specialization && w.specialization.toLowerCase().includes(q))
    );

    const matchedSocieties = scopedSocieties.filter(
      (s) =>
        s.name.toLowerCase().includes(q) ||
        s.code.toLowerCase().includes(q) ||
        s.contactPerson.toLowerCase().includes(q)
    );

    const matchedBulk = scopedBulkRequests.filter(
      (b) =>
        b.title.toLowerCase().includes(q) ||
        b.clientName.toLowerCase().includes(q) ||
        b.requiredTrade.toLowerCase().includes(q)
    );

    const matchedSOS = scopedSOSAlerts.filter(
      (a) =>
        a.workerName.toLowerCase().includes(q) ||
        a.location.toLowerCase().includes(q) ||
        a.trade.toLowerCase().includes(q) ||
        a.notes.toLowerCase().includes(q)
    );

    const matchedTasks = scopedSocietyTaskPrices.filter(
      (t) =>
        t.taskName.toLowerCase().includes(q) ||
        t.trade.toLowerCase().includes(q) ||
        t.description.toLowerCase().includes(q)
    );

    return {
      workers: matchedWorkers,
      societies: matchedSocieties,
      bulkRequests: matchedBulk,
      sosAlerts: matchedSOS,
      taskPrices: matchedTasks,
    };
  };

  return (
    <AppContext.Provider
      value={{
        currentAccount,
        currentNode,
        breadcrumbTrail,
        isFederation,
        isSociety,
        switchRole,
        allHierarchyNodes: nodes,
        scopedManagedNodes,
        scopedSocieties,
        scopedWorkers,
        scopedSOSAlerts,
        scopedBulkRequests,
        rateCards,
        federationBasePrices,
        updateFederationBasePrice,
        societyTaskPrices,
        scopedSocietyTaskPrices,
        updateSocietyTaskPrice,
        addSocietyTaskPrice,
        areaDemandData,
        rebalanceAreaWorkers,
        auditEvents,
        notifications,
        isForecastReadinessPassed,
        toggleDemandReadiness,
        login,
        logout,
        addChildNode,
        addWorker,
        dispatchSOS,
        resolveSOS,
        proposeBulkTeam,
        confirmBulkRequest,
        addRateCard,
        toggleRateCardStatus,
        updateRateCardRate,
        markNotificationRead,
        markAllNotificationsRead,
        searchGlobal,
      }}
    >
      {children}
    </AppContext.Provider>
  );
};

export const useApp = () => {
  const context = useContext(AppContext);
  if (!context) {
    throw new Error("useApp must be used within an AppProvider");
  }
  return context;
};
