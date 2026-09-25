import React, { useState, useMemo } from "react";
import { useApp } from "../context/AppContext";
import { Button } from "../components/common/Button";
import { Badge } from "../components/common/Badge";
import { Modal } from "../components/common/Modal";
import { ExportModal } from "../components/common/ExportModal";
import { useNavigate } from "react-router-dom";
import {
  BlueCollarTrade,
  FederationBasePrice,
  SocietyServiceTaskPrice,
  Worker,
  HierarchyNode,
} from "../types";
import {
  AreaChart,
  Area,
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  Legend,
} from "recharts";

export const DashboardScreen: React.FC = () => {
  const {
    currentAccount,
    currentNode,
    isFederation,
    isSociety,
    switchRole,
    scopedSocieties,
    scopedWorkers,
    scopedSOSAlerts,
    scopedBulkRequests,
    federationBasePrices,
    updateFederationBasePrice,
    societyTaskPrices,
    scopedSocietyTaskPrices,
    updateSocietyTaskPrice,
    addSocietyTaskPrice,
    areaDemandData,
    rebalanceAreaWorkers,
    addWorker,
  } = useApp();

  const navigate = useNavigate();

  // Common modals
  const [isExportOpen, setIsExportOpen] = useState(false);

  // Federation Modals & State
  const [selectedTradeFilter, setSelectedTradeFilter] = useState<string>("All Trades");
  const [selectedAreaFilter, setSelectedAreaFilter] = useState<string>("All Areas");
  const [editingBasePrice, setEditingBasePrice] = useState<FederationBasePrice | null>(null);
  const [newBaseHourly, setNewBaseHourly] = useState<number>(360);
  const [newFloorRate, setNewFloorRate] = useState<number>(280);
  const [newCeilingRate, setNewCeilingRate] = useState<number>(520);
  const [newVisitCharge, setNewVisitCharge] = useState<number>(150);
  const [selectedSocietyInspect, setSelectedSocietyInspect] = useState<HierarchyNode | null>(null);
  const [mobilizingArea, setMobilizingArea] = useState<{
    id: string;
    name: string;
    trade: BlueCollarTrade;
    needed: number;
  } | null>(null);

  // Society Modals & State
  const [workerFilterAvailability, setWorkerFilterAvailability] = useState<string>("All");
  const [workerSearchQuery, setWorkerSearchQuery] = useState<string>("");
  const [editingTaskPrice, setEditingTaskPrice] = useState<SocietyServiceTaskPrice | null>(null);
  const [newTaskPriceValue, setNewTaskPriceValue] = useState<number>(180);
  const [isAddTaskOpen, setIsAddTaskOpen] = useState(false);
  const [isAddWorkerOpen, setIsAddWorkerOpen] = useState(false);

  // Add worker form states
  const [newWorkerName, setNewWorkerName] = useState("");
  const [newWorkerTrade, setNewWorkerTrade] = useState<BlueCollarTrade>("Plumbing & Sanitation");
  const [newWorkerSpec, setNewWorkerSpec] = useState("");
  const [newWorkerPhone, setNewWorkerPhone] = useState("");
  const [newWorkerExp, setNewWorkerExp] = useState(6);
  const [newWorkerCluster, setNewWorkerCluster] = useState("Hadapsar & Magarpatta");

  // Add task form states
  const [newCustomTaskName, setNewCustomTaskName] = useState("");
  const [newCustomTaskCategory, setNewCustomTaskCategory] = useState("Sanitary Fittings");
  const [newCustomTaskDesc, setNewCustomTaskDesc] = useState("");
  const [newCustomTaskDuration, setNewCustomTaskDuration] = useState(30);
  const [newCustomTaskPrice, setNewCustomTaskPrice] = useState(250);

  // Federation Societies Table filter & pagination
  const [societySearchQuery, setSocietySearchQuery] = useState<string>("");
  const [societyTradeFilter, setSocietyTradeFilter] = useState<string>("All Trades");
  const [societyPage, setSocietyPage] = useState<number>(1);
  const SOCIETIES_PER_PAGE = 10;

  // General counts
  const openSOSCount = scopedSOSAlerts.filter((a) => a.status === "open").length;
  const activeWorkersCount = scopedWorkers.filter((w) => w.status === "Active").length;
  const availableWorkersCount = scopedWorkers.filter((w) => w.currentAvailability === "Available").length;
  const onJobWorkersCount = scopedWorkers.filter((w) => w.currentAvailability === "On-Job").length;
  const totalCompletedJobs = scopedWorkers.reduce((acc, w) => acc + w.jobsCompleted, 0);
  const totalGrossDisbursed = scopedWorkers.reduce((acc, w) => acc + w.totalEarnings, 0);

  // Filtered Societies for Federation view
  const filteredSocieties = useMemo(() => {
    return scopedSocieties.filter((soc) => {
      const matchTrade =
        societyTradeFilter === "All Trades" ||
        (soc.primaryTrade && soc.primaryTrade.toLowerCase().includes(societyTradeFilter.toLowerCase())) ||
        (societyTradeFilter === "Plumbers" && soc.primaryTrade?.includes("Plumbing")) ||
        (societyTradeFilter === "Electricians" && soc.primaryTrade?.includes("Electrical")) ||
        (societyTradeFilter === "Gardeners" && soc.primaryTrade?.includes("Gardening")) ||
        (societyTradeFilter === "Caregivers" && soc.primaryTrade?.includes("Caregiving"));

      const matchSearch =
        !societySearchQuery ||
        soc.name.toLowerCase().includes(societySearchQuery.toLowerCase()) ||
        soc.code.toLowerCase().includes(societySearchQuery.toLowerCase()) ||
        (soc.districtName && soc.districtName.toLowerCase().includes(societySearchQuery.toLowerCase())) ||
        (soc.region && soc.region.toLowerCase().includes(societySearchQuery.toLowerCase())) ||
        soc.contactPerson.toLowerCase().includes(societySearchQuery.toLowerCase());

      return matchTrade && matchSearch;
    });
  }, [scopedSocieties, societyTradeFilter, societySearchQuery]);

  const totalSocietyPages = Math.ceil(filteredSocieties.length / SOCIETIES_PER_PAGE) || 1;
  const paginatedSocieties = useMemo(() => {
    const start = (societyPage - 1) * SOCIETIES_PER_PAGE;
    return filteredSocieties.slice(start, start + SOCIETIES_PER_PAGE);
  }, [filteredSocieties, societyPage]);

  // Filtered Area Demand
  const filteredAreaDemand = useMemo(() => {
    return areaDemandData.filter((item) => {
      const matchTrade =
        selectedTradeFilter === "All Trades" ||
        item.trade.toLowerCase().includes(selectedTradeFilter.toLowerCase()) ||
        (selectedTradeFilter === "Plumbers" && item.trade.includes("Plumbing")) ||
        (selectedTradeFilter === "Electricians" && item.trade.includes("Electrical")) ||
        (selectedTradeFilter === "Gardeners" && item.trade.includes("Gardening")) ||
        (selectedTradeFilter === "Caregivers" && item.trade.includes("Caregiving"));

      const matchArea =
        selectedAreaFilter === "All Areas" || item.areaName.includes(selectedAreaFilter);

      return matchTrade && matchArea;
    });
  }, [areaDemandData, selectedTradeFilter, selectedAreaFilter]);

  // Chart data for Demand vs Availability
  const demandComparisonChartData = useMemo(() => {
    return filteredAreaDemand.slice(0, 6).map((item) => ({
      area: item.areaName.split("&")[0].replace("IT Corridor", "").trim(),
      Demand: item.weeklyDemandRequests,
      Available: item.availableWorkers,
      trade: item.trade,
    }));
  }, [filteredAreaDemand]);

  // Filtered Society Member Workers
  const filteredSocietyWorkers = useMemo(() => {
    return scopedWorkers.filter((w) => {
      const matchAvail =
        workerFilterAvailability === "All" || w.currentAvailability === workerFilterAvailability;
      const matchSearch =
        !workerSearchQuery ||
        w.name.toLowerCase().includes(workerSearchQuery.toLowerCase()) ||
        w.phone.includes(workerSearchQuery) ||
        (w.specialization && w.specialization.toLowerCase().includes(workerSearchQuery.toLowerCase())) ||
        w.locationCluster.toLowerCase().includes(workerSearchQuery.toLowerCase());

      return matchAvail && matchSearch;
    });
  }, [scopedWorkers, workerFilterAvailability, workerSearchQuery]);

  // Handle Save Federation Base Price
  const handleSaveBasePrice = () => {
    if (!editingBasePrice) return;
    updateFederationBasePrice(editingBasePrice.id, {
      baseHourlyRate: newBaseHourly,
      minFloorRate: newFloorRate,
      maxCeilingRate: newCeilingRate,
      recommendedVisitCharge: newVisitCharge,
    });
    setEditingBasePrice(null);
  };

  // Handle Save Society Task Price
  const handleSaveTaskPrice = () => {
    if (!editingTaskPrice) return;
    updateSocietyTaskPrice(editingTaskPrice.id, newTaskPriceValue);
    setEditingTaskPrice(null);
  };

  // Handle Create New Custom Task Price
  const handleCreateTask = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newCustomTaskName.trim()) return;

    addSocietyTaskPrice({
      societyId: currentNode?.id || "soc-plumbers-pune",
      trade: currentNode?.primaryTrade || "Plumbing & Sanitation",
      taskName: newCustomTaskName,
      category: newCustomTaskCategory,
      description: newCustomTaskDesc || "Custom work specification configured by primary society.",
      estimatedDurationMins: Number(newCustomTaskDuration),
      price: Number(newCustomTaskPrice),
      materialCostPolicy: "Labor only (Customer provides parts)",
      federationBaseFloor: Math.round(Number(newCustomTaskPrice) * 0.75),
      federationBaseCeiling: Math.round(Number(newCustomTaskPrice) * 1.5),
      status: "Active",
      isPopular: false,
    });

    setNewCustomTaskName("");
    setNewCustomTaskDesc("");
    setIsAddTaskOpen(false);
  };

  // Handle Add Member Worker
  const handleCreateWorker = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newWorkerName.trim()) return;

    addWorker({
      name: newWorkerName,
      trade: newWorkerTrade,
      specialization: newWorkerSpec || `${newWorkerTrade} Specialist`,
      phone: newWorkerPhone || "+91 98220 00000",
      experienceYears: Number(newWorkerExp),
      locationCluster: newWorkerCluster,
    });

    setNewWorkerName("");
    setNewWorkerSpec("");
    setNewWorkerPhone("");
    setIsAddWorkerOpen(false);
  };

  return (
    <div className="space-y-7 pb-10">
      {/* =========================================================================
          PAGE HEADER: Self-Explaining, Clean & Modern Role Presentation
         ========================================================================= */}
      <div className="bg-white border border-stone-200/90 p-5 sm:p-6 rounded-2xl shadow-xs flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <div className="flex flex-wrap items-center gap-2 mb-1.5">
            <span className="text-[10px] uppercase font-bold tracking-wider px-2.5 py-0.5 rounded-full bg-amber-100 text-amber-900 border border-amber-300/60">
              {isFederation ? "Cooperative Federation Portal" : "Cooperative Society Console"}
            </span>
            <span className="text-stone-300">·</span>
            <Badge tone="olive" size="sm">
              Live Verified Node
            </Badge>
            <span className="text-stone-300">·</span>
            <span className="text-xs text-stone-500 font-mono">
              {currentNode?.code || (isFederation ? "MH-FED-024" : "MH-PUN-PLM-2021")}
            </span>
          </div>

          <h1 className="font-headline text-2xl sm:text-3xl font-bold text-stone-900 tracking-tight">
            {currentNode?.name || (isFederation ? "Maharashtra State Labour & Gig Cooperative Federation" : "Pune Metropolitan Plumbers & Sanitary Technicians Cooperative Society")}
          </h1>

          <p className="font-body text-xs sm:text-sm text-stone-600 mt-1 leading-relaxed max-w-3xl">
            {isFederation
              ? "Overseeing all enrolled primary societies across districts, tracking area-wise trade demand vs worker availability, and enforcing statutory base price bands."
              : "Grassroots worker cooperative managing technician member rosters, fair dispatch queues, and granular task pricing (Tap Replacement, Shower Change, etc.)."}
          </p>
        </div>

        {/* Quick Role Toggle & Actions */}
        <div className="flex flex-wrap items-center gap-2.5 shrink-0 pt-2 md:pt-0">
          <button
            type="button"
            onClick={() => switchRole(isFederation ? "society" : "federation")}
            className="flex items-center gap-1.5 px-3 py-2 rounded-xl bg-amber-50 hover:bg-amber-100 border border-amber-300/80 text-xs font-bold text-amber-900 shadow-xs transition-colors"
            title="Seamlessly switch view between Federation and Society"
          >
            <span className="material-symbols-outlined text-sm">sync_alt</span>
            <span>Switch to {isFederation ? "Society View (Plumbers)" : "Federation View"}</span>
          </button>

          <Button
            variant="outlined"
            size="md"
            icon="file_download"
            className="rounded-xl text-xs font-semibold"
            onClick={() => setIsExportOpen(true)}
          >
            Export Ledger
          </Button>

          {isSociety && (
            <Button
              variant="primary"
              size="md"
              icon="person_add"
              className="rounded-xl text-xs font-bold shadow-xs"
              onClick={() => setIsAddWorkerOpen(true)}
            >
              Enrol Member
            </Button>
          )}
        </div>
      </div>

      {/* EMERGENCY SOS BANNER (if critical incidents exist) */}
      {openSOSCount > 0 && (
        <div className="bg-red-50 border border-red-200 p-4 rounded-xl flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 shadow-xs">
          <div className="flex items-center gap-3">
            <div className="w-9 h-9 rounded-xl bg-red-600 text-white flex items-center justify-center font-bold animate-pulse shadow-sm">
              <span className="material-symbols-outlined text-lg">e911_emergency</span>
            </div>
            <div>
              <span className="font-bold text-xs text-red-950 uppercase tracking-wider block">
                {openSOSCount} Emergency Incident{openSOSCount > 1 ? "s" : ""} Awaiting Dispatch
              </span>
              <span className="text-xs text-red-800/90 block">
                Job site hazard reported. Co-op relief routing protocol standby.
              </span>
            </div>
          </div>
          <Button
            variant="secondary"
            size="sm"
            icon="arrow_forward"
            className="rounded-lg text-xs"
            onClick={() => navigate("/sos")}
          >
            Open SOS Queue ({openSOSCount})
          </Button>
        </div>
      )}

      {/* =========================================================================
          KEY METRICS CARDS (Role Specific)
         ========================================================================= */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        {isFederation ? (
          <>
            {/* FEDERATION KPI 1: Enrolled Societies */}
            <div className="bg-white border border-stone-200/90 p-5 rounded-2xl shadow-xs space-y-2 hover:border-amber-700/30 transition-all">
              <div className="flex items-center justify-between text-xs font-bold text-stone-500 uppercase tracking-wider">
                <span>Enrolled Societies</span>
                <span className="w-8 h-8 rounded-lg bg-amber-50 text-amber-900 flex items-center justify-center">
                  <span className="material-symbols-outlined text-lg">hub</span>
                </span>
              </div>
              <div className="font-headline text-3xl font-bold text-stone-900">
                {scopedSocieties.length} Societies
              </div>
              <div className="flex items-center justify-between text-[11px] text-stone-500 pt-1 border-t border-stone-100">
                <span>Directly Affiliated</span>
                <span className="text-emerald-700 font-bold">100% Compliant</span>
              </div>
            </div>

            {/* FEDERATION KPI 2: Total Member Workers Across Societies */}
            <div className="bg-white border border-stone-200/90 p-5 rounded-2xl shadow-xs space-y-2 hover:border-amber-700/30 transition-all">
              <div className="flex items-center justify-between text-xs font-bold text-stone-500 uppercase tracking-wider">
                <span>Total Member Workers</span>
                <span className="w-8 h-8 rounded-lg bg-orange-50 text-orange-900 flex items-center justify-center">
                  <span className="material-symbols-outlined text-lg">engineering</span>
                </span>
              </div>
              <div className="font-headline text-3xl font-bold text-amber-900">
                {scopedWorkers.length > 0 ? scopedWorkers.length : 185} Active
              </div>
              <div className="flex items-center justify-between text-[11px] text-stone-500 pt-1 border-t border-stone-100">
                <span>Cooperative Guild Members</span>
                <span className="text-emerald-700 font-bold">+18% This Quarter</span>
              </div>
            </div>

            {/* FEDERATION KPI 3: Area Demand Fulfillment */}
            <div className="bg-white border border-stone-200/90 p-5 rounded-2xl shadow-xs space-y-2 hover:border-amber-700/30 transition-all">
              <div className="flex items-center justify-between text-xs font-bold text-stone-500 uppercase tracking-wider">
                <span>Demand Fulfillment</span>
                <span className="w-8 h-8 rounded-lg bg-emerald-50 text-emerald-900 flex items-center justify-center">
                  <span className="material-symbols-outlined text-lg">trending_up</span>
                </span>
              </div>
              <div className="font-headline text-3xl font-bold text-emerald-800">
                93.8%
              </div>
              <div className="flex items-center justify-between text-[11px] text-stone-500 pt-1 border-t border-stone-100">
                <span>Across 6 Urban Clusters</span>
                <span className="text-amber-800 font-bold">3 Deficit Zones</span>
              </div>
            </div>

            {/* FEDERATION KPI 4: Base Tariff Compliance */}
            <div className="bg-white border border-stone-200/90 p-5 rounded-2xl shadow-xs space-y-2 hover:border-amber-700/30 transition-all">
              <div className="flex items-center justify-between text-xs font-bold text-stone-500 uppercase tracking-wider">
                <span>Tariff Floor Adherence</span>
                <span className="w-8 h-8 rounded-lg bg-amber-50 text-amber-900 flex items-center justify-center">
                  <span className="material-symbols-outlined text-lg">gavel</span>
                </span>
              </div>
              <div className="font-headline text-3xl font-bold text-stone-900">
                99.4%
              </div>
              <div className="flex items-center justify-between text-[11px] text-stone-500 pt-1 border-t border-stone-100">
                <span>Anchored to State Gazette</span>
                <span className="text-emerald-700 font-bold">Zero Undercutting</span>
              </div>
            </div>
          </>
        ) : (
          <>
            {/* SOCIETY KPI 1: Enrolled Member Workers */}
            <div className="bg-white border border-stone-200/90 p-5 rounded-2xl shadow-xs space-y-2 hover:border-amber-700/30 transition-all">
              <div className="flex items-center justify-between text-xs font-bold text-stone-500 uppercase tracking-wider">
                <span>Society Members</span>
                <span className="w-8 h-8 rounded-lg bg-amber-50 text-amber-900 flex items-center justify-center">
                  <span className="material-symbols-outlined text-lg">groups</span>
                </span>
              </div>
              <div className="font-headline text-3xl font-bold text-stone-900">
                {scopedWorkers.length} Workers
              </div>
              <div className="flex items-center justify-between text-[11px] text-stone-500 pt-1 border-t border-stone-100">
                <span>Primary Shareholder-Members</span>
                <span className="text-emerald-700 font-bold">100% Verified</span>
              </div>
            </div>

            {/* SOCIETY KPI 2: Available Right Now */}
            <div className="bg-white border border-stone-200/90 p-5 rounded-2xl shadow-xs space-y-2 hover:border-amber-700/30 transition-all">
              <div className="flex items-center justify-between text-xs font-bold text-stone-500 uppercase tracking-wider">
                <span>Available for Jobs</span>
                <span className="w-8 h-8 rounded-lg bg-emerald-50 text-emerald-900 flex items-center justify-center">
                  <span className="material-symbols-outlined text-lg">check_circle</span>
                </span>
              </div>
              <div className="font-headline text-3xl font-bold text-emerald-800">
                {availableWorkersCount} Available
              </div>
              <div className="flex items-center justify-between text-[11px] text-stone-500 pt-1 border-t border-stone-100">
                <span>On-Job: {onJobWorkersCount}</span>
                <span className="text-stone-600 font-bold">Instant Dispatch</span>
              </div>
            </div>

            {/* SOCIETY KPI 3: Jobs Completed */}
            <div className="bg-white border border-stone-200/90 p-5 rounded-2xl shadow-xs space-y-2 hover:border-amber-700/30 transition-all">
              <div className="flex items-center justify-between text-xs font-bold text-stone-500 uppercase tracking-wider">
                <span>Completed Tasks</span>
                <span className="w-8 h-8 rounded-lg bg-orange-50 text-orange-900 flex items-center justify-center">
                  <span className="material-symbols-outlined text-lg">task_alt</span>
                </span>
              </div>
              <div className="font-headline text-3xl font-bold text-amber-900">
                {totalCompletedJobs.toLocaleString()}
              </div>
              <div className="flex items-center justify-between text-[11px] text-stone-500 pt-1 border-t border-stone-100">
                <span>4.92 ★ Average Rating</span>
                <span className="text-emerald-700 font-bold">98.5% On-Time</span>
              </div>
            </div>

            {/* SOCIETY KPI 4: Disbursed Member Volume */}
            <div className="bg-white border border-stone-200/90 p-5 rounded-2xl shadow-xs space-y-2 hover:border-amber-700/30 transition-all">
              <div className="flex items-center justify-between text-xs font-bold text-stone-500 uppercase tracking-wider">
                <span>Disbursed to Members</span>
                <span className="w-8 h-8 rounded-lg bg-stone-100 text-stone-800 flex items-center justify-center">
                  <span className="material-symbols-outlined text-lg">payments</span>
                </span>
              </div>
              <div className="font-headline text-3xl font-bold text-stone-900">
                ₹{(totalGrossDisbursed / 100000).toFixed(1)}L
              </div>
              <div className="flex items-center justify-between text-[11px] text-stone-500 pt-1 border-t border-stone-100">
                <span>5% Health/Welfare Vault</span>
                <span className="font-mono font-bold text-amber-900">
                  ₹{(totalGrossDisbursed * 0.05).toLocaleString("en-IN", { maximumFractionDigits: 0 })}
                </span>
              </div>
            </div>
          </>
        )}
      </div>

      {/* =========================================================================
          IF COOPERATIVE FEDERATION:
          1. Enrolled Cooperative Societies Directory
          2. Area-wise Demand vs Availability for Services (Plumbers, Electricians...)
          3. Federation Base Price Setting for Services
         ========================================================================= */}
      {isFederation && (
        <div className="space-y-8">
          {/* ---------------------------------------------------------------------
              FEDERATION SECTION 1: ALL ENROLLED COOPERATIVE SOCIETIES
             --------------------------------------------------------------------- */}
          <div className="bg-white border border-stone-200/90 rounded-2xl shadow-xs overflow-hidden space-y-4 p-5 sm:p-6">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-stone-200/70 pb-4">
              <div>
                <div className="flex items-center gap-2">
                  <span className="material-symbols-outlined text-amber-800 text-lg">domain</span>
                  <h2 className="font-headline font-bold text-lg sm:text-xl text-stone-900">
                    Enrolled Cooperative Societies
                  </h2>
                </div>
                <p className="text-xs text-stone-600 mt-0.5">
                  Complete registry of primary labour and technician societies registered under this state federation.
                </p>
              </div>

              <div className="flex items-center gap-2">
                <Badge tone="terracotta" size="sm">
                  {scopedSocieties.length} Primary Societies Affiliated
                </Badge>
              </div>
            </div>

            {/* Explanatory callout for federation oversight */}
            <div className="p-3.5 rounded-xl bg-amber-50/60 border border-amber-200/80 flex items-start gap-2.5 text-xs text-amber-950">
              <span className="material-symbols-outlined text-amber-800 text-base mt-0.5 shrink-0">
                info
              </span>
              <p className="leading-relaxed">
                <strong>Federation Governance Model:</strong> As a state apex body, the federation models India's statutory cooperative tier. Primary societies hold real worker-members and background checks, while the federation monitors collective health, audit logs, and cross-society mobility.
              </p>
            </div>

            {/* Filter & Search Bar for Societies */}
            <div className="flex flex-col sm:flex-row items-center justify-between gap-3 pt-1">
              <div className="flex items-center gap-1.5 overflow-x-auto w-full sm:w-auto pb-1 sm:pb-0">
                {["All Trades", "Plumbers", "Electricians", "Gardeners", "Caregivers"].map((trade) => (
                  <button
                    key={trade}
                    type="button"
                    onClick={() => {
                      setSocietyTradeFilter(trade);
                      setSocietyPage(1);
                    }}
                    className={`px-3 py-1 rounded-full text-xs font-semibold whitespace-nowrap transition-all ${
                      societyTradeFilter === trade
                        ? "bg-[#B45309] text-white shadow-xs"
                        : "bg-stone-100 text-stone-600 hover:bg-stone-200/80"
                    }`}
                  >
                    {trade}
                  </button>
                ))}
              </div>

              <div className="relative w-full sm:w-64">
                <span className="material-symbols-outlined absolute left-3 top-2.5 text-stone-400 text-sm">
                  search
                </span>
                <input
                  type="text"
                  placeholder="Search 79 societies..."
                  value={societySearchQuery}
                  onChange={(e) => {
                    setSocietySearchQuery(e.target.value);
                    setSocietyPage(1);
                  }}
                  className="w-full pl-9 pr-3 py-1.5 rounded-xl border border-stone-200 text-xs bg-stone-50/50 focus:bg-white focus:outline-none focus:ring-2 focus:ring-amber-700/20"
                />
              </div>
            </div>

            {/* Enrolled Societies Table */}
            <div className="overflow-x-auto">
              <table className="w-full text-left border-collapse text-xs">
                <thead>
                  <tr className="border-b border-stone-200 bg-stone-50/80 text-[11px] uppercase tracking-wider text-stone-500 font-bold">
                    <th className="py-3 px-3.5">Society Name & Code</th>
                    <th className="py-3 px-3.5">Primary Trade</th>
                    <th className="py-3 px-3.5">District / Zone</th>
                    <th className="py-3 px-3.5 text-center">Active Members</th>
                    <th className="py-3 px-3.5 text-center">Rating</th>
                    <th className="py-3 px-3.5 text-center">Tariff Compliance</th>
                    <th className="py-3 px-3.5">Contact Secretary</th>
                    <th className="py-3 px-3.5 text-right">Actions</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-stone-100">
                  {paginatedSocieties.length === 0 ? (
                    <tr>
                      <td colSpan={8} className="py-8 text-center text-stone-400 text-xs">
                        No enrolled societies matching "{societySearchQuery || societyTradeFilter}"
                      </td>
                    </tr>
                  ) : (
                    paginatedSocieties.map((soc) => (
                      <tr key={soc.id} className="hover:bg-amber-50/30 transition-colors">
                        <td className="py-3.5 px-3.5">
                          <span className="font-bold text-stone-900 block text-xs sm:text-sm">
                            {soc.name}
                          </span>
                          <span className="font-mono text-[10px] text-stone-400">
                            {soc.code} · Est. {soc.establishedYear}
                          </span>
                        </td>

                        <td className="py-3.5 px-3.5">
                          <span className="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-[11px] font-semibold bg-amber-100 text-amber-900 border border-amber-200">
                            <span className="material-symbols-outlined text-xs">
                              {soc.primaryTrade?.includes("Plumbing")
                                ? "plumbing"
                                : soc.primaryTrade?.includes("Electrical")
                                ? "bolt"
                                : soc.primaryTrade?.includes("Gardening")
                                ? "yard"
                                : soc.primaryTrade?.includes("Caregiving")
                                ? "health_and_safety"
                                : "build"}
                            </span>
                            {soc.primaryTrade || "General Maintenance"}
                          </span>
                        </td>

                        <td className="py-3.5 px-3.5 text-stone-700">
                          <span className="font-semibold text-stone-900 block">{soc.districtName || "Pune"}</span>
                          <span className="text-[11px] text-stone-500 truncate max-w-[150px] block">
                            {soc.region}
                          </span>
                        </td>

                        <td className="py-3.5 px-3.5 text-center font-mono font-bold text-stone-900">
                          {soc.activeWorkersCount || 24} workers
                        </td>

                        <td className="py-3.5 px-3.5 text-center">
                          <span className="inline-flex items-center gap-1 font-bold text-amber-900 bg-amber-50 px-2 py-0.5 rounded-md border border-amber-200 text-[11px]">
                            ★ {soc.performanceRating || 4.88}
                          </span>
                        </td>

                        <td className="py-3.5 px-3.5 text-center">
                          <span className="font-mono font-bold text-emerald-800 text-[11px]">
                            {soc.complianceRate || 99.2}%
                          </span>
                        </td>

                        <td className="py-3.5 px-3.5">
                          <span className="font-medium text-stone-900 block">{soc.contactPerson}</span>
                          <span className="text-[11px] text-stone-500 font-mono">{soc.contactPhone}</span>
                        </td>

                        <td className="py-3.5 px-3.5 text-right">
                          <button
                            type="button"
                            onClick={() => setSelectedSocietyInspect(soc)}
                            className="px-2.5 py-1 rounded-lg border border-stone-200 hover:border-amber-700 hover:bg-amber-50 text-xs font-semibold text-stone-700 transition-colors"
                          >
                            Inspect
                          </button>
                        </td>
                      </tr>
                    ))
                  )}
                </tbody>
              </table>
            </div>

            {/* Pagination Controls */}
            <div className="flex flex-col sm:flex-row items-center justify-between gap-3 pt-3 border-t border-stone-100 text-xs text-stone-500">
              <div>
                Showing <span className="font-bold text-stone-800">{filteredSocieties.length === 0 ? 0 : (societyPage - 1) * SOCIETIES_PER_PAGE + 1}</span> to{" "}
                <span className="font-bold text-stone-800">{Math.min(societyPage * SOCIETIES_PER_PAGE, filteredSocieties.length)}</span> of{" "}
                <span className="font-bold text-stone-800">{filteredSocieties.length}</span> societies
              </div>
              <div className="flex items-center gap-1.5">
                <button
                  type="button"
                  disabled={societyPage === 1}
                  onClick={() => setSocietyPage((p) => Math.max(1, p - 1))}
                  className="px-2.5 py-1 rounded-lg border border-stone-200 text-xs font-medium disabled:opacity-40 disabled:cursor-not-allowed hover:bg-stone-50 transition-colors"
                >
                  Previous
                </button>
                <span className="px-2 font-mono text-xs text-stone-700">
                  Page {societyPage} of {totalSocietyPages}
                </span>
                <button
                  type="button"
                  disabled={societyPage >= totalSocietyPages}
                  onClick={() => setSocietyPage((p) => Math.min(totalSocietyPages, p + 1))}
                  className="px-2.5 py-1 rounded-lg border border-stone-200 text-xs font-medium disabled:opacity-40 disabled:cursor-not-allowed hover:bg-stone-50 transition-colors"
                >
                  Next
                </button>
              </div>
            </div>
          </div>

          {/* ---------------------------------------------------------------------
              FEDERATION SECTION 2: AREA DEMAND & AVAILABILITY OF SERVICES
              (Plumbers, electricians, gardeners, caregivers etc.)
             --------------------------------------------------------------------- */}
          <div className="bg-white border border-stone-200/90 rounded-2xl shadow-xs overflow-hidden space-y-5 p-5 sm:p-6">
            <div className="flex flex-col md:flex-row md:items-center justify-between gap-3 border-b border-stone-200/70 pb-4">
              <div>
                <div className="flex items-center gap-2">
                  <span className="material-symbols-outlined text-amber-800 text-lg">analytics</span>
                  <h2 className="font-headline font-bold text-lg sm:text-xl text-stone-900">
                    Area Demand & Worker Availability Matrix
                  </h2>
                </div>
                <p className="text-xs text-stone-600 mt-0.5">
                  Real-time telemetry showing customer booking demand vs available technicians for <strong>Plumbers, Electricians, Gardeners, Caregivers</strong>, etc.
                </p>
              </div>

              {/* Trade Filters */}
              <div className="flex flex-wrap items-center gap-1.5 bg-stone-100/80 p-1 rounded-xl border border-stone-200">
                {[
                  "All Trades",
                  "Plumbers",
                  "Electricians",
                  "Gardeners",
                  "Caregivers",
                ].map((tradeFilter) => (
                  <button
                    key={tradeFilter}
                    type="button"
                    onClick={() => setSelectedTradeFilter(tradeFilter)}
                    className={`px-3 py-1.5 rounded-lg text-xs font-bold transition-all ${
                      selectedTradeFilter === tradeFilter
                        ? "bg-white text-amber-900 shadow-xs border border-stone-200"
                        : "text-stone-600 hover:text-stone-900"
                    }`}
                  >
                    {tradeFilter}
                  </button>
                ))}
              </div>
            </div>

            {/* Explanatory callout for area demand/availability */}
            <div className="p-3.5 rounded-xl bg-emerald-50/60 border border-emerald-200/80 flex items-start gap-2.5 text-xs text-emerald-950">
              <span className="material-symbols-outlined text-emerald-800 text-base mt-0.5 shrink-0">
                balance
              </span>
              <div className="leading-relaxed space-y-0.5">
                <p>
                  <strong>Why Area Telemetry Matters:</strong> Private platforms run predatory surge pricing when demand outstrips supply. SkillsKart federations instead monitor deficits in real time and enable cooperative rebalancing—dispatching certified technicians from nearby surplus societies to keep prices steady.
                </p>
              </div>
            </div>

            {/* Demand vs Availability Recharts Comparison */}
            <div className="bg-stone-50 border border-stone-200/70 rounded-xl p-4 space-y-2">
              <div className="flex items-center justify-between">
                <span className="text-xs font-bold text-stone-800">
                  Weekly Booking Calls vs Active Technician Density ({selectedTradeFilter})
                </span>
                <span className="text-[11px] text-stone-500 font-mono">
                  Live Dispatch Telemetry
                </span>
              </div>
              <div className="h-52 w-full pt-2">
                <ResponsiveContainer width="100%" height="100%">
                  <BarChart data={demandComparisonChartData} margin={{ top: 5, right: 10, left: -20, bottom: 0 }}>
                    <CartesianGrid strokeDasharray="3 3" stroke="#E8DFD3" vertical={false} />
                    <XAxis dataKey="area" tick={{ fontSize: 11, fill: "#78716C" }} stroke="#D8C6B1" />
                    <YAxis tick={{ fontSize: 11, fill: "#78716C" }} stroke="#D8C6B1" />
                    <Tooltip
                      contentStyle={{
                        backgroundColor: "#FFFFFF",
                        borderColor: "#D8C6B1",
                        borderRadius: "8px",
                        fontSize: "12px",
                        boxShadow: "0 4px 12px rgba(0,0,0,0.08)",
                      }}
                    />
                    <Legend wrapperStyle={{ fontSize: "11px", paddingTop: "4px" }} />
                    <Bar dataKey="Demand" name="Customer Booking Calls" fill="#C2410C" radius={[4, 4, 0, 0]} />
                    <Bar dataKey="Available" name="Active Workers Available" fill="#4D7C0F" radius={[4, 4, 0, 0]} />
                  </BarChart>
                </ResponsiveContainer>
              </div>
            </div>

            {/* Area Grid Cards */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3.5 pt-1">
              {filteredAreaDemand.map((item) => {
                const isDeficit = item.gapStatus === "Deficit";
                const isSurplus = item.gapStatus === "Surplus";

                return (
                  <div
                    key={item.id}
                    className="p-4 rounded-xl border border-stone-200/80 bg-white hover:border-amber-700/30 hover:shadow-sm transition-all flex flex-col justify-between space-y-3"
                  >
                    <div>
                      <div className="flex items-start justify-between gap-2">
                        <div>
                          <h3 className="font-bold text-xs sm:text-sm text-stone-900 line-clamp-1">
                            {item.areaName}
                          </h3>
                          <p className="text-[11px] text-stone-500">{item.district} Urban Cluster</p>
                        </div>

                        <span
                          className={`px-2 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider shrink-0 ${
                            isDeficit
                              ? "bg-red-100 text-red-800 border border-red-200"
                              : isSurplus
                              ? "bg-blue-100 text-blue-800 border border-blue-200"
                              : "bg-emerald-100 text-emerald-800 border border-emerald-200"
                          }`}
                        >
                          {isDeficit ? `Deficit (-${item.deficitCount})` : isSurplus ? `Surplus (+${Math.abs(item.deficitCount)})` : "Balanced"}
                        </span>
                      </div>

                      <div className="mt-2.5 flex items-center gap-1.5 text-xs font-semibold text-amber-900">
                        <span className="material-symbols-outlined text-sm">handyman</span>
                        <span>{item.trade}</span>
                      </div>

                      {/* Demand vs Available metrics */}
                      <div className="grid grid-cols-2 gap-2 mt-3 pt-2.5 border-t border-stone-100">
                        <div className="bg-stone-50 p-2 rounded-lg text-center">
                          <span className="text-[10px] uppercase font-bold text-stone-500 block">
                            Weekly Demand
                          </span>
                          <span className="font-headline font-bold text-base text-stone-900">
                            {item.weeklyDemandRequests} calls
                          </span>
                        </div>
                        <div className="bg-stone-50 p-2 rounded-lg text-center">
                          <span className="text-[10px] uppercase font-bold text-stone-500 block">
                            Available Capacity
                          </span>
                          <span className="font-headline font-bold text-base text-emerald-800">
                            {item.availableWorkers} workers
                          </span>
                        </div>
                      </div>
                    </div>

                    <div className="pt-2 border-t border-stone-100 flex items-center justify-between">
                      <span className="text-[11px] text-stone-500 font-mono">
                        Avg Response: {item.avgResponseTimeMins}m
                      </span>

                      {isDeficit && (
                        <button
                          type="button"
                          onClick={() => setMobilizingArea({
                            id: item.id,
                            name: item.areaName,
                            trade: item.trade,
                            needed: item.deficitCount,
                          })}
                          className="flex items-center gap-1 px-2.5 py-1 rounded-lg bg-red-50 hover:bg-red-100 border border-red-200 text-red-900 text-xs font-bold transition-colors"
                        >
                          <span className="material-symbols-outlined text-xs">local_shipping</span>
                          <span>Rebalance ({item.deficitCount})</span>
                        </button>
                      )}
                    </div>
                  </div>
                );
              })}
            </div>
          </div>

          {/* ---------------------------------------------------------------------
              FEDERATION SECTION 3: BASE PRICE SETTING FOR SERVICES
             --------------------------------------------------------------------- */}
          <div className="bg-white border border-stone-200/90 rounded-2xl shadow-xs overflow-hidden space-y-4 p-5 sm:p-6">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-stone-200/70 pb-4">
              <div>
                <div className="flex items-center gap-2">
                  <span className="material-symbols-outlined text-amber-800 text-lg">price_change</span>
                  <h2 className="font-headline font-bold text-lg sm:text-xl text-stone-900">
                    Federation Base Price & Tariff Schedule
                  </h2>
                </div>
                <p className="text-xs text-stone-600 mt-0.5">
                  Configure statutory base prices, minimum wage floor protections, and anti-gouging caps across different kinds of services.
                </p>
              </div>

              <Badge tone="olive" size="sm">
                State Gazette Anchored
              </Badge>
            </div>

            {/* Explanatory callout for base pricing */}
            <div className="p-3.5 rounded-xl bg-orange-50/60 border border-orange-200/80 flex items-start gap-2.5 text-xs text-orange-950">
              <span className="material-symbols-outlined text-orange-800 text-base mt-0.5 shrink-0">
                verified
              </span>
              <p className="leading-relaxed">
                <strong>Why Federations Set Base Prices:</strong> Similar to how municipal transport authorities set taxi fare cards (like Bharat Taxi's RTO benchmark), the cooperative federation sets the statutory floor rate for Plumbers, Electricians, Gardeners, Caregivers, etc. Member societies set specific task rates (Tap, Shower, Switchboard) within these bands.
              </p>
            </div>

            {/* Base Price Table */}
            <div className="overflow-x-auto">
              <table className="w-full text-left border-collapse text-xs">
                <thead>
                  <tr className="border-b border-stone-200 bg-stone-50/80 text-[11px] uppercase tracking-wider text-stone-500 font-bold">
                    <th className="py-3 px-3.5">Service Trade</th>
                    <th className="py-3 px-3.5">Statutory Gazette Anchor</th>
                    <th className="py-3 px-3.5 text-center">Minimum Floor Rate</th>
                    <th className="py-3 px-3.5 text-center">Standard Base Hourly</th>
                    <th className="py-3 px-3.5 text-center">Ceiling Cap</th>
                    <th className="py-3 px-3.5 text-center">Min. Callout Charge</th>
                    <th className="py-3 px-3.5 text-right">Action</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-stone-100">
                  {federationBasePrices.map((bp) => (
                    <tr key={bp.id} className="hover:bg-amber-50/30 transition-colors">
                      <td className="py-3.5 px-3.5">
                        <span className="font-bold text-stone-900 block text-xs sm:text-sm">
                          {bp.trade}
                        </span>
                        <span className="text-[10px] text-stone-500">{bp.category}</span>
                      </td>

                      <td className="py-3.5 px-3.5 text-stone-600">
                        <span className="font-mono text-[11px] block">{bp.statutoryWageRef}</span>
                        <span className="text-[10px] text-stone-400">Updated {bp.lastUpdated}</span>
                      </td>

                      <td className="py-3.5 px-3.5 text-center">
                        <span className="font-mono font-bold text-amber-900 text-xs sm:text-sm bg-amber-50 px-2 py-0.5 rounded-md border border-amber-200/80">
                          ₹{bp.minFloorRate}/hr
                        </span>
                        <span className="text-[10px] text-stone-400 block mt-0.5">Strict Floor</span>
                      </td>

                      <td className="py-3.5 px-3.5 text-center">
                        <span className="font-mono font-bold text-stone-900 text-sm">
                          ₹{bp.baseHourlyRate}/hr
                        </span>
                        <span className="text-[10px] text-stone-500 block mt-0.5">Recommended</span>
                      </td>

                      <td className="py-3.5 px-3.5 text-center">
                        <span className="font-mono font-semibold text-stone-700 text-xs">
                          ₹{bp.maxCeilingRate}/hr
                        </span>
                        <span className="text-[10px] text-stone-400 block mt-0.5">Anti-Gouging</span>
                      </td>

                      <td className="py-3.5 px-3.5 text-center">
                        <span className="font-mono font-bold text-emerald-800 text-xs">
                          ₹{bp.recommendedVisitCharge}
                        </span>
                        <span className="text-[10px] text-stone-400 block mt-0.5">Inspection/Call</span>
                      </td>

                      <td className="py-3.5 px-3.5 text-right">
                        <Button
                          variant="outlined"
                          size="sm"
                          icon="edit"
                          className="rounded-lg text-xs"
                          onClick={() => {
                            setEditingBasePrice(bp);
                            setNewBaseHourly(bp.baseHourlyRate);
                            setNewFloorRate(bp.minFloorRate);
                            setNewCeilingRate(bp.maxCeilingRate);
                            setNewVisitCharge(bp.recommendedVisitCharge);
                          }}
                        >
                          Set Base Price
                        </Button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      )}

      {/* =========================================================================
          IF COOPERATIVE SOCIETY:
          1. Member Workers Dashboard (Directly on Home Page)
          2. Set Particular Price for Particular Kind of Work (Tap Replacement, Shower...)
         ========================================================================= */}
      {isSociety && (
        <div className="space-y-8">
          {/* ---------------------------------------------------------------------
              SOCIETY SECTION 1: WORKERS WHO ARE MEMBERS OF THEIR SOCIETY
             --------------------------------------------------------------------- */}
          <div className="bg-white border border-stone-200/90 rounded-2xl shadow-xs overflow-hidden space-y-4 p-5 sm:p-6">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-stone-200/70 pb-4">
              <div>
                <div className="flex items-center gap-2">
                  <span className="material-symbols-outlined text-amber-800 text-lg">badge</span>
                  <h2 className="font-headline font-bold text-lg sm:text-xl text-stone-900">
                    Society Member Workers Roster
                  </h2>
                </div>
                <p className="text-xs text-stone-600 mt-0.5">
                  Complete workforce ledger of member technicians belonging to <strong>{currentNode?.name}</strong>.
                </p>
              </div>

              <div className="flex items-center gap-2">
                <Button
                  variant="primary"
                  size="sm"
                  icon="person_add"
                  className="rounded-xl text-xs font-bold"
                  onClick={() => setIsAddWorkerOpen(true)}
                >
                  Enrol Member Worker
                </Button>
              </div>
            </div>

            {/* Explanatory callout for society worker membership */}
            <div className="p-3.5 rounded-xl bg-amber-50/60 border border-amber-200/80 flex items-start gap-2.5 text-xs text-amber-950">
              <span className="material-symbols-outlined text-amber-800 text-base mt-0.5 shrink-0">
                shield
              </span>
              <p className="leading-relaxed">
                <strong>Cooperative Member Protection:</strong> Unlike private gig platforms that treat technicians as expendable contractor algorithms, SkillsKart cooperative workers are legal shareholder-members. Coverage under e-Shram, BOCW statutory boards, and group health insurance is tied to membership, not app-session activity.
              </p>
            </div>

            {/* Filter and Search Toolbar */}
            <div className="flex flex-col sm:flex-row items-center justify-between gap-3 pt-1">
              <div className="relative w-full sm:w-80">
                <span className="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-stone-400 text-base">
                  search
                </span>
                <input
                  type="text"
                  value={workerSearchQuery}
                  onChange={(e) => setWorkerSearchQuery(e.target.value)}
                  placeholder="Search worker by name, trade, phone, cluster..."
                  className="w-full bg-stone-50 border border-stone-200/80 rounded-xl pl-9 pr-3 py-2 text-xs text-stone-900 focus:outline-none focus:border-amber-700"
                />
              </div>

              <div className="flex items-center gap-1.5 self-start sm:self-auto">
                <span className="text-xs text-stone-500 font-medium">Availability:</span>
                {["All", "Available", "On-Job", "Off-Duty"].map((avail) => (
                  <button
                    key={avail}
                    type="button"
                    onClick={() => setWorkerFilterAvailability(avail)}
                    className={`px-2.5 py-1 rounded-lg text-xs font-semibold transition-colors ${
                      workerFilterAvailability === avail
                        ? "bg-amber-100 text-amber-900 border border-amber-300 font-bold"
                        : "bg-stone-100 text-stone-600 hover:bg-stone-200/60"
                    }`}
                  >
                    {avail}
                  </button>
                ))}
              </div>
            </div>

            {/* Member Workers Table */}
            <div className="overflow-x-auto">
              <table className="w-full text-left border-collapse text-xs">
                <thead>
                  <tr className="border-b border-stone-200 bg-stone-50/80 text-[11px] uppercase tracking-wider text-stone-500 font-bold">
                    <th className="py-3 px-3.5">Member Technician</th>
                    <th className="py-3 px-3.5">Trade & Specialization</th>
                    <th className="py-3 px-3.5 text-center">Status</th>
                    <th className="py-3 px-3.5 text-center">Experience</th>
                    <th className="py-3 px-3.5 text-center">Jobs / Rating</th>
                    <th className="py-3 px-3.5 text-center">Monthly Payout</th>
                    <th className="py-3 px-3.5">Welfare & Social Security</th>
                    <th className="py-3 px-3.5 text-right">Location Cluster</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-stone-100">
                  {filteredSocietyWorkers.map((worker) => (
                    <tr key={worker.id} className="hover:bg-amber-50/30 transition-colors">
                      <td className="py-3.5 px-3.5">
                        <div className="flex items-center gap-2.5">
                          <div className="w-8 h-8 rounded-full bg-amber-800 text-white font-bold flex items-center justify-center text-xs">
                            {worker.name.charAt(0)}
                          </div>
                          <div>
                            <span className="font-bold text-stone-900 block text-xs sm:text-sm">
                              {worker.name}
                            </span>
                            <span className="font-mono text-[10px] text-stone-400">
                              {worker.phone} · ID: {worker.id.toUpperCase()}
                            </span>
                          </div>
                        </div>
                      </td>

                      <td className="py-3.5 px-3.5">
                        <span className="font-semibold text-amber-900 block">
                          {worker.trade}
                        </span>
                        <span className="text-[11px] text-stone-500 line-clamp-1">
                          {worker.specialization || "Standard Certified"}
                        </span>
                      </td>

                      <td className="py-3.5 px-3.5 text-center">
                        <span
                          className={`inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-[10px] font-bold ${
                            worker.currentAvailability === "Available"
                              ? "bg-emerald-100 text-emerald-800 border border-emerald-200"
                              : worker.currentAvailability === "On-Job"
                              ? "bg-amber-100 text-amber-800 border border-amber-200"
                              : "bg-stone-100 text-stone-600 border border-stone-200"
                          }`}
                        >
                          <span
                            className={`w-1.5 h-1.5 rounded-full ${
                              worker.currentAvailability === "Available"
                                ? "bg-emerald-600"
                                : worker.currentAvailability === "On-Job"
                                ? "bg-amber-600"
                                : "bg-stone-400"
                            }`}
                          />
                          {worker.currentAvailability}
                        </span>
                      </td>

                      <td className="py-3.5 px-3.5 text-center font-mono font-semibold text-stone-700">
                        {worker.experienceYears} yrs
                      </td>

                      <td className="py-3.5 px-3.5 text-center">
                        <span className="font-bold text-stone-900 block text-xs">
                          {worker.jobsCompleted} tasks
                        </span>
                        <span className="text-amber-800 font-bold text-[11px]">
                          ★ {worker.rating}
                        </span>
                      </td>

                      <td className="py-3.5 px-3.5 text-center font-mono">
                        <span className="font-bold text-stone-900 text-xs">
                          ₹{worker.totalEarnings.toLocaleString("en-IN")}
                        </span>
                      </td>

                      <td className="py-3.5 px-3.5">
                        <div className="flex flex-wrap gap-1">
                          <span className="px-1.5 py-0.5 rounded text-[9px] font-bold bg-emerald-50 text-emerald-800 border border-emerald-200">
                            e-Shram ✓
                          </span>
                          <span className="px-1.5 py-0.5 rounded text-[9px] font-bold bg-emerald-50 text-emerald-800 border border-emerald-200">
                            BOCW ✓
                          </span>
                          <span className="px-1.5 py-0.5 rounded text-[9px] font-bold bg-blue-50 text-blue-800 border border-blue-200">
                            Co-op Insured
                          </span>
                        </div>
                      </td>

                      <td className="py-3.5 px-3.5 text-right text-stone-600 font-medium text-[11px]">
                        {worker.locationCluster}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>

          {/* ---------------------------------------------------------------------
              SOCIETY SECTION 2: PARTICULAR PRICES FOR PARTICULAR KIND OF WORK
              (like Plumbers setting "Tap Replacement", "Shower change" etc.)
             --------------------------------------------------------------------- */}
          <div className="bg-white border border-stone-200/90 rounded-2xl shadow-xs overflow-hidden space-y-5 p-5 sm:p-6">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-stone-200/70 pb-4">
              <div>
                <div className="flex items-center gap-2">
                  <span className="material-symbols-outlined text-amber-800 text-lg">sell</span>
                  <h2 className="font-headline font-bold text-lg sm:text-xl text-stone-900">
                    Particular Work Item Rate Schedule
                  </h2>
                </div>
                <p className="text-xs text-stone-600 mt-0.5">
                  Set particular customer prices for specific repair/installation tasks (e.g. <strong>"Tap Replacement"</strong>, <strong>"Shower change"</strong>, etc.).
                </p>
              </div>

              <Button
                variant="primary"
                size="sm"
                icon="add_circle"
                className="rounded-xl text-xs font-bold"
                onClick={() => setIsAddTaskOpen(true)}
              >
                Add Work Item
              </Button>
            </div>

            {/* Explanatory callout for society granular task pricing */}
            <div className="p-3.5 rounded-xl bg-orange-50/60 border border-orange-200/80 flex items-start gap-2.5 text-xs text-orange-950">
              <span className="material-symbols-outlined text-orange-800 text-base mt-0.5 shrink-0">
                tune
              </span>
              <p className="leading-relaxed">
                <strong>Society Pricing Autonomy:</strong> As a primary cooperative society, you have direct authority to price individual repair tasks to reflect your local tool, labor, and travel realities. The platform verifies each rate against the Federation Base Floor to prevent destructive undercutting.
              </p>
            </div>

            {/* Task Item Cards Grid */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {scopedSocietyTaskPrices.map((task) => (
                <div
                  key={task.id}
                  className="p-4 rounded-xl border border-stone-200/90 bg-white hover:border-amber-700/40 hover:shadow-md transition-all flex flex-col justify-between space-y-3"
                >
                  <div>
                    <div className="flex items-start justify-between gap-2">
                      <div>
                        <span className="text-[10px] uppercase font-bold tracking-wider text-amber-800 bg-amber-100/70 px-2 py-0.5 rounded-md">
                          {task.category}
                        </span>
                        <h3 className="font-bold text-sm text-stone-900 mt-1.5">
                          {task.taskName}
                        </h3>
                      </div>
                      {task.isPopular && (
                        <span className="text-[9px] font-bold uppercase tracking-wider px-1.5 py-0.5 rounded bg-orange-100 text-orange-800 border border-orange-200">
                          Popular
                        </span>
                      )}
                    </div>

                    <p className="text-xs text-stone-600 mt-2 leading-relaxed line-clamp-2">
                      {task.description}
                    </p>

                    <div className="mt-3 flex items-center justify-between text-xs text-stone-500 pt-2 border-t border-stone-100">
                      <span className="flex items-center gap-1">
                        <span className="material-symbols-outlined text-stone-400 text-sm">timer</span>
                        <span>{task.estimatedDurationMins} mins</span>
                      </span>
                      <span className="text-[11px] text-stone-600">
                        {task.materialCostPolicy}
                      </span>
                    </div>
                  </div>

                  {/* Price Banner & Action */}
                  <div className="pt-2.5 border-t border-stone-100 flex items-center justify-between">
                    <div>
                      <span className="text-[10px] uppercase font-bold text-stone-400 block">
                        Society Rate
                      </span>
                      <span className="font-headline font-bold text-xl text-stone-900">
                        ₹{task.price}
                      </span>
                    </div>

                    <div className="text-right space-y-1">
                      <span className="text-[10px] text-emerald-700 font-bold block">
                        Band: ₹{task.federationBaseFloor} - ₹{task.federationBaseCeiling}
                      </span>
                      <Button
                        variant="outlined"
                        size="sm"
                        icon="edit"
                        className="rounded-lg text-xs"
                        onClick={() => {
                          setEditingTaskPrice(task);
                          setNewTaskPriceValue(task.price);
                        }}
                      >
                        Adjust Price
                      </Button>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* =========================================================================
          MODALS & DIALOGS
         ========================================================================= */}
      {/* 1. EDIT FEDERATION BASE PRICE MODAL */}
      {editingBasePrice && (
        <Modal
          isOpen={true}
          onClose={() => setEditingBasePrice(null)}
          title={`Set Federation Base Price: ${editingBasePrice.trade}`}
          subtitle={`Statutory wage regulation anchored to ${editingBasePrice.statutoryWageRef}`}
          maxWidth="md"
        >
          <div className="space-y-4">
            <div className="p-3 bg-amber-50 rounded-xl border border-amber-200 text-xs text-amber-950">
              <p>
                <strong>Statutory Wage Protection:</strong> Setting the floor prevents member societies and clients from establishing compensation below minimum living wages.
              </p>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3.5">
              <div>
                <label className="block text-xs font-bold text-stone-800 mb-1">
                  Standard Base Hourly (₹) *
                </label>
                <input
                  type="number"
                  min={100}
                  max={2000}
                  step={10}
                  value={newBaseHourly}
                  onChange={(e) => setNewBaseHourly(Number(e.target.value))}
                  className="w-full bg-stone-50 border border-stone-300 rounded-xl px-3 py-2 text-sm font-bold text-stone-900 focus:outline-none focus:border-amber-700 font-mono"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-stone-800 mb-1">
                  Mandatory Floor Rate (₹) *
                </label>
                <input
                  type="number"
                  min={100}
                  max={newBaseHourly}
                  step={10}
                  value={newFloorRate}
                  onChange={(e) => setNewFloorRate(Number(e.target.value))}
                  className="w-full bg-stone-50 border border-stone-300 rounded-xl px-3 py-2 text-sm font-bold text-stone-900 focus:outline-none focus:border-amber-700 font-mono"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-stone-800 mb-1">
                  Ceiling Cap Rate (₹) *
                </label>
                <input
                  type="number"
                  min={newBaseHourly}
                  max={3000}
                  step={10}
                  value={newCeilingRate}
                  onChange={(e) => setNewCeilingRate(Number(e.target.value))}
                  className="w-full bg-stone-50 border border-stone-300 rounded-xl px-3 py-2 text-sm font-bold text-stone-900 focus:outline-none focus:border-amber-700 font-mono"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-stone-800 mb-1">
                  Recommended Visit Fee (₹) *
                </label>
                <input
                  type="number"
                  min={50}
                  max={500}
                  step={10}
                  value={newVisitCharge}
                  onChange={(e) => setNewVisitCharge(Number(e.target.value))}
                  className="w-full bg-stone-50 border border-stone-300 rounded-xl px-3 py-2 text-sm font-bold text-stone-900 focus:outline-none focus:border-amber-700 font-mono"
                />
              </div>
            </div>

            <div className="flex justify-end gap-2.5 pt-3 border-t border-stone-200">
              <Button
                variant="outlined"
                size="md"
                className="rounded-xl text-xs"
                onClick={() => setEditingBasePrice(null)}
              >
                Cancel
              </Button>
              <Button
                variant="primary"
                size="md"
                icon="check"
                className="rounded-xl text-xs font-bold"
                onClick={handleSaveBasePrice}
              >
                Save Base Price
              </Button>
            </div>
          </div>
        </Modal>
      )}

      {/* 2. EDIT SOCIETY TASK PRICE MODAL (e.g. Tap Replacement, Shower change) */}
      {editingTaskPrice && (
        <Modal
          isOpen={true}
          onClose={() => setEditingTaskPrice(null)}
          title={`Set Task Price: ${editingTaskPrice.taskName}`}
          subtitle={`Current Price: ₹${editingTaskPrice.price} · Trade: ${editingTaskPrice.trade}`}
          maxWidth="sm"
        >
          <div className="space-y-4">
            <div>
              <label className="block text-xs font-bold text-stone-800 mb-1">
                Customer Task Price (₹) *
              </label>
              <input
                type="number"
                min={editingTaskPrice.federationBaseFloor}
                max={editingTaskPrice.federationBaseCeiling * 1.5}
                step={10}
                value={newTaskPriceValue}
                onChange={(e) => setNewTaskPriceValue(Number(e.target.value))}
                className="w-full bg-stone-50 border border-stone-300 rounded-xl px-3 py-2 text-base font-bold text-stone-900 focus:outline-none focus:border-amber-700 font-mono"
              />
            </div>

            <div className="p-3 rounded-xl bg-stone-50 border border-stone-200 text-xs space-y-1">
              <div className="flex items-center justify-between">
                <span className="text-stone-500">Federation Price Band:</span>
                <span className="font-mono font-bold text-stone-800">
                  ₹{editingTaskPrice.federationBaseFloor} - ₹{editingTaskPrice.federationBaseCeiling}
                </span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-stone-500">Compliance Status:</span>
                <span
                  className={`font-bold ${
                    newTaskPriceValue >= editingTaskPrice.federationBaseFloor &&
                    newTaskPriceValue <= editingTaskPrice.federationBaseCeiling
                      ? "text-emerald-700"
                      : "text-amber-800"
                  }`}
                >
                  {newTaskPriceValue >= editingTaskPrice.federationBaseFloor &&
                  newTaskPriceValue <= editingTaskPrice.federationBaseCeiling
                    ? "✓ Compliant with Federation Band"
                    : "⚠️ Deviation requires council notation"}
                </span>
              </div>
            </div>

            <div className="flex justify-end gap-2.5 pt-2">
              <Button
                variant="outlined"
                size="md"
                className="rounded-xl text-xs"
                onClick={() => setEditingTaskPrice(null)}
              >
                Cancel
              </Button>
              <Button
                variant="primary"
                size="md"
                icon="check"
                className="rounded-xl text-xs font-bold"
                onClick={handleSaveTaskPrice}
              >
                Update Price
              </Button>
            </div>
          </div>
        </Modal>
      )}

      {/* 3. ADD NEW WORK ITEM MODAL (Society) */}
      {isAddTaskOpen && (
        <Modal
          isOpen={true}
          onClose={() => setIsAddTaskOpen(false)}
          title="Add Specific Work Task to Society Catalogue"
          subtitle="Configure a new task rate (e.g. Tap Replacement, Shower change, Cistern repair)"
          maxWidth="md"
        >
          <form onSubmit={handleCreateTask} className="space-y-4">
            <div>
              <label className="block text-xs font-bold text-stone-800 mb-1">
                Specific Work Item / Task Name *
              </label>
              <input
                type="text"
                required
                placeholder="e.g. Overhead Tank Float Valve Replacement"
                value={newCustomTaskName}
                onChange={(e) => setNewCustomTaskName(e.target.value)}
                className="w-full bg-stone-50 border border-stone-300 rounded-xl px-3 py-2 text-xs text-stone-900 focus:outline-none focus:border-amber-700"
              />
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
              <div>
                <label className="block text-xs font-bold text-stone-800 mb-1">
                  Category *
                </label>
                <input
                  type="text"
                  required
                  placeholder="e.g. Faucets & Valves"
                  value={newCustomTaskCategory}
                  onChange={(e) => setNewCustomTaskCategory(e.target.value)}
                  className="w-full bg-stone-50 border border-stone-300 rounded-xl px-3 py-2 text-xs text-stone-900 focus:outline-none focus:border-amber-700"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-stone-800 mb-1">
                  Estimated Duration (Mins) *
                </label>
                <input
                  type="number"
                  min={10}
                  max={480}
                  step={5}
                  value={newCustomTaskDuration}
                  onChange={(e) => setNewCustomTaskDuration(Number(e.target.value))}
                  className="w-full bg-stone-50 border border-stone-300 rounded-xl px-3 py-2 text-xs text-stone-900 focus:outline-none focus:border-amber-700 font-mono"
                />
              </div>
            </div>

            <div>
              <label className="block text-xs font-bold text-stone-800 mb-1">
                Standard Customer Price (₹) *
              </label>
              <input
                type="number"
                min={50}
                max={5000}
                step={10}
                value={newCustomTaskPrice}
                onChange={(e) => setNewCustomTaskPrice(Number(e.target.value))}
                className="w-full bg-stone-50 border border-stone-300 rounded-xl px-3 py-2 text-sm font-bold text-stone-900 focus:outline-none focus:border-amber-700 font-mono"
              />
            </div>

            <div>
              <label className="block text-xs font-bold text-stone-800 mb-1">
                Work Scope & Tool Description
              </label>
              <textarea
                rows={2}
                placeholder="Describe scope, tools required, and quality check steps..."
                value={newCustomTaskDesc}
                onChange={(e) => setNewCustomTaskDesc(e.target.value)}
                className="w-full bg-stone-50 border border-stone-300 rounded-xl p-3 text-xs text-stone-900 focus:outline-none focus:border-amber-700"
              />
            </div>

            <div className="flex justify-end gap-2.5 pt-2 border-t border-stone-200">
              <Button
                variant="outlined"
                size="md"
                className="rounded-xl text-xs"
                onClick={() => setIsAddTaskOpen(false)}
              >
                Cancel
              </Button>
              <Button
                variant="primary"
                size="md"
                icon="check"
                className="rounded-xl text-xs font-bold"
              >
                Register Work Task
              </Button>
            </div>
          </form>
        </Modal>
      )}

      {/* 4. ENROL MEMBER WORKER MODAL (Society) */}
      {isAddWorkerOpen && (
        <Modal
          isOpen={true}
          onClose={() => setIsAddWorkerOpen(false)}
          title="Enrol New Member Worker"
          subtitle={`Directly register a skilled trade technician to ${currentNode?.name}`}
          maxWidth="md"
        >
          <form onSubmit={handleCreateWorker} className="space-y-4">
            <div>
              <label className="block text-xs font-bold text-stone-800 mb-1">
                Full Worker Name *
              </label>
              <input
                type="text"
                required
                placeholder="e.g. Suresh V. Patil"
                value={newWorkerName}
                onChange={(e) => setNewWorkerName(e.target.value)}
                className="w-full bg-stone-50 border border-stone-300 rounded-xl px-3 py-2 text-xs text-stone-900 focus:outline-none focus:border-amber-700"
              />
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
              <div>
                <label className="block text-xs font-bold text-stone-800 mb-1">
                  Trade Classification *
                </label>
                <select
                  value={newWorkerTrade}
                  onChange={(e) => setNewWorkerTrade(e.target.value as BlueCollarTrade)}
                  className="w-full bg-stone-50 border border-stone-300 rounded-xl px-3 py-2 text-xs text-stone-900 focus:outline-none focus:border-amber-700"
                >
                  <option value="Plumbing & Sanitation">Plumbing & Sanitation (Plumbers)</option>
                  <option value="Electrical & Wiring">Electrical & Wiring (Electricians)</option>
                  <option value="Gardening & Landscaping">Gardening & Landscaping (Gardeners)</option>
                  <option value="Caregiving & Elder Care">Caregiving & Elder Care (Caregivers)</option>
                  <option value="Appliance Repair & HVAC">Appliance Repair & HVAC</option>
                  <option value="Carpentry & Woodwork">Carpentry & Woodwork</option>
                  <option value="Painting & Waterproofing">Painting & Waterproofing</option>
                  <option value="Housekeeping & Domestic Help">Housekeeping & Domestic Help</option>
                </select>
              </div>

              <div>
                <label className="block text-xs font-bold text-stone-800 mb-1">
                  Specialization Skill *
                </label>
                <input
                  type="text"
                  placeholder="e.g. Bathroom Fixtures & Diverters"
                  value={newWorkerSpec}
                  onChange={(e) => setNewWorkerSpec(e.target.value)}
                  className="w-full bg-stone-50 border border-stone-300 rounded-xl px-3 py-2 text-xs text-stone-900 focus:outline-none focus:border-amber-700"
                />
              </div>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
              <div>
                <label className="block text-xs font-bold text-stone-800 mb-1">
                  Mobile Number *
                </label>
                <input
                  type="text"
                  required
                  placeholder="+91 98000 00000"
                  value={newWorkerPhone}
                  onChange={(e) => setNewWorkerPhone(e.target.value)}
                  className="w-full bg-stone-50 border border-stone-300 rounded-xl px-3 py-2 text-xs text-stone-900 focus:outline-none focus:border-amber-700 font-mono"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-stone-800 mb-1">
                  Experience (Years) *
                </label>
                <input
                  type="number"
                  min={1}
                  max={45}
                  value={newWorkerExp}
                  onChange={(e) => setNewWorkerExp(Number(e.target.value))}
                  className="w-full bg-stone-50 border border-stone-300 rounded-xl px-3 py-2 text-xs text-stone-900 focus:outline-none focus:border-amber-700 font-mono"
                />
              </div>
            </div>

            <div>
              <label className="block text-xs font-bold text-stone-800 mb-1">
                Operational Cluster / Zone
              </label>
              <input
                type="text"
                value={newWorkerCluster}
                onChange={(e) => setNewWorkerCluster(e.target.value)}
                placeholder="e.g. Hadapsar & Magarpatta City"
                className="w-full bg-stone-50 border border-stone-300 rounded-xl px-3 py-2 text-xs text-stone-900 focus:outline-none focus:border-amber-700"
              />
            </div>

            <div className="p-3 bg-emerald-50 rounded-xl border border-emerald-200 text-xs text-emerald-950">
              <span className="font-bold block">✓ Automatic Social Security Integration:</span>
              <span>Enrolling this worker will automatically generate their cooperative member ledger identity, link statutory e-Shram verification, and activate the Group Health Insurance policy.</span>
            </div>

            <div className="flex justify-end gap-2.5 pt-2 border-t border-stone-200">
              <Button
                variant="outlined"
                size="md"
                className="rounded-xl text-xs"
                onClick={() => setIsAddWorkerOpen(false)}
              >
                Cancel
              </Button>
              <Button
                variant="primary"
                size="md"
                icon="how_to_reg"
                className="rounded-xl text-xs font-bold"
              >
                Complete Enrolment
              </Button>
            </div>
          </form>
        </Modal>
      )}

      {/* 5. MOBILIZE AREA RELIEF DIALOG */}
      {mobilizingArea && (
        <Modal
          isOpen={true}
          onClose={() => setMobilizingArea(null)}
          title={`Mobilize Capacity: ${mobilizingArea.name}`}
          subtitle={`Current Deficit: ${mobilizingArea.needed} ${mobilizingArea.trade}`}
          maxWidth="sm"
        >
          <div className="space-y-4">
            <p className="text-xs text-stone-600 leading-relaxed">
              Dispatch certified relief technicians from neighboring surplus societies to rebalance <strong>{mobilizingArea.name}</strong>.
            </p>

            <div className="p-3 bg-amber-50 rounded-xl border border-amber-200 text-xs text-amber-950 space-y-1">
              <div className="flex justify-between">
                <span>Available Surplus Pool:</span>
                <span className="font-bold text-emerald-800">42 verified workers ready</span>
              </div>
              <div className="flex justify-between">
                <span>Recommended Relief Dispatch:</span>
                <span className="font-bold text-amber-900">+{mobilizingArea.needed} technicians</span>
              </div>
            </div>

            <div className="flex justify-end gap-2.5 pt-2">
              <Button
                variant="outlined"
                size="md"
                className="rounded-xl text-xs"
                onClick={() => setMobilizingArea(null)}
              >
                Cancel
              </Button>
              <Button
                variant="primary"
                size="md"
                icon="local_shipping"
                className="rounded-xl text-xs font-bold"
                onClick={() => {
                  rebalanceAreaWorkers(mobilizingArea.id, mobilizingArea.trade, mobilizingArea.needed);
                  setMobilizingArea(null);
                }}
              >
                Confirm Dispatch (+{mobilizingArea.needed})
              </Button>
            </div>
          </div>
        </Modal>
      )}

      {/* 6. INSPECT SOCIETY MODAL */}
      {selectedSocietyInspect && (
        <Modal
          isOpen={true}
          onClose={() => setSelectedSocietyInspect(null)}
          title={selectedSocietyInspect.name}
          subtitle={`Primary Cooperative Node: ${selectedSocietyInspect.code}`}
          maxWidth="md"
        >
          <div className="space-y-4 text-xs text-stone-700">
            <div className="grid grid-cols-2 gap-3 bg-stone-50 p-3 rounded-xl border border-stone-200">
              <div>
                <span className="text-stone-400 block uppercase font-bold text-[10px]">Primary Trade:</span>
                <span className="font-bold text-stone-900 text-sm">{selectedSocietyInspect.primaryTrade || "Multi-trade"}</span>
              </div>
              <div>
                <span className="text-stone-400 block uppercase font-bold text-[10px]">District Jurisdiction:</span>
                <span className="font-bold text-stone-900 text-sm">{selectedSocietyInspect.districtName} ({selectedSocietyInspect.region})</span>
              </div>
              <div>
                <span className="text-stone-400 block uppercase font-bold text-[10px]">Member Technicians:</span>
                <span className="font-bold text-amber-900 text-sm">{selectedSocietyInspect.activeWorkersCount || 24} Verified</span>
              </div>
              <div>
                <span className="text-stone-400 block uppercase font-bold text-[10px]">Performance & Compliance:</span>
                <span className="font-bold text-emerald-800 text-sm">★ {selectedSocietyInspect.performanceRating || 4.88} ({selectedSocietyInspect.complianceRate || 99.2}%)</span>
              </div>
            </div>

            <div className="space-y-1">
              <span className="text-stone-400 uppercase font-bold text-[10px]">Secretary / Contact Person:</span>
              <p className="font-bold text-stone-900">{selectedSocietyInspect.contactPerson}</p>
              <p className="font-mono text-stone-600">{selectedSocietyInspect.contactPhone} · {selectedSocietyInspect.contactEmail}</p>
            </div>

            <div className="flex justify-end pt-2">
              <Button
                variant="primary"
                size="md"
                className="rounded-xl text-xs"
                onClick={() => setSelectedSocietyInspect(null)}
              >
                Close Inspector
              </Button>
            </div>
          </div>
        </Modal>
      )}

      {/* Export Modal */}
      <ExportModal
        isOpen={isExportOpen}
        onClose={() => setIsExportOpen(false)}
        datasetName={isFederation ? "Societies" : "Workers"}
        data={isFederation ? scopedSocieties : scopedWorkers}
      />
    </div>
  );
};
