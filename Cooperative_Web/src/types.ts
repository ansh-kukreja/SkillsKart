export type HierarchyTier = "national" | "federation" | "society";

export type BlueCollarTrade =
  | "Plumbing & Sanitation"
  | "Electrical & Wiring"
  | "Gardening & Landscaping"
  | "Caregiving & Elder Care"
  | "Appliance Repair & HVAC"
  | "Carpentry & Woodwork"
  | "Carpentry & Assembly"
  | "Carpentry & Furniture Craft"
  | "Masonry & Civil Repairs"
  | "Painting & Waterproofing"
  | "Housekeeping & Domestic Help"
  | "Housekeeping & Facility Operations"
  | "Facility Cleaning & Pest Control"
  | "Commercial Equipment Maintenance";

export interface HierarchyNode {
  id: string;
  tier: HierarchyTier;
  name: string;
  code: string;
  parentId: string | null;
  contactPerson: string;
  contactPhone: string;
  contactEmail: string;
  region: string;
  stateName?: string;
  districtName?: string;
  primaryTrade?: BlueCollarTrade;
  activeSocietiesCount?: number;
  activeWorkersCount?: number;
  establishedYear: number;
  status: "Active";
  performanceRating?: number;
  complianceRate?: number;
}

export interface Worker {
  id: string;
  name: string;
  societyId: string;
  district: string;
  state: string;
  trade: BlueCollarTrade;
  specialization?: string;
  experienceYears: number;
  phone: string;
  email: string;
  status: "Active" | "Inactive";
  rating: number;
  jobsCompleted: number;
  totalEarnings: number; // in INR
  joinedDate: string;
  currentAvailability: "Available" | "On-Job" | "Off-Duty";
  locationCluster: string;
  welfareStatus?: {
    eShramVerified: boolean;
    bocwBoardRegistered: boolean;
    groupInsuranceActive: boolean;
    insurancePolicyNumber?: string;
  };
}

export interface FederationBasePrice {
  id: string;
  trade: BlueCollarTrade;
  category: string;
  baseHourlyRate: number; // e.g. 380
  minFloorRate: number;   // statutory minimum wage floor e.g. 300
  maxCeilingRate: number; // consumer protection cap e.g. 550
  unit: string;           // "per hour", "per visit"
  recommendedVisitCharge: number; // e.g. 150
  statutoryWageRef: string; // e.g. "MH Labour Gazette Notif. 104/2026"
  lastUpdated: string;
  lastUpdatedBy: string;
  complianceNotes: string;
}

export interface SocietyServiceTaskPrice {
  id: string;
  societyId: string;
  trade: BlueCollarTrade;
  taskName: string; // e.g. "Tap Replacement", "Shower change", "Drain Unclogging"
  category: string;
  description: string;
  estimatedDurationMins: number;
  price: number; // in INR
  materialCostPolicy: "Labor only (Customer provides parts)" | "Includes basic consumables" | "Standard kit included";
  federationBaseFloor: number;
  federationBaseCeiling: number;
  status: "Active" | "Draft";
  updatedAt: string;
  isPopular?: boolean;
}

export interface AreaServiceDemandAvailability {
  id: string;
  areaName: string;
  district: string;
  trade: BlueCollarTrade;
  weeklyDemandRequests: number;
  availableWorkers: number;
  gapStatus: "Deficit" | "Balanced" | "Surplus";
  deficitCount: number; // positive if shortage, negative if surplus
  avgResponseTimeMins: number;
  avgCustomerRating: number;
  trendPercentage: number; // e.g. +24% demand growth
  urgencyLevel: "Critical" | "Moderate" | "Optimal";
}

export interface SOSAlert {
  id: string;
  workerId: string;
  workerName: string;
  trade: BlueCollarTrade;
  societyId: string;
  district: string;
  state: string;
  type: "worker_emergency" | "technical_safety" | "fraud_dispute";
  location: string;
  coordinates: string;
  timestamp: string;
  severity: "critical" | "high" | "medium";
  notes: string;
  status: "open" | "dispatched" | "resolved";
  dispatchedWorkerId?: string;
  dispatchedWorkerName?: string;
  dispatchedTimestamp?: string;
  resolvedTimestamp?: string;
}

export interface BulkRequest {
  id: string;
  clientName: string;
  clientType: "Government / Municipal" | "Commercial Facility" | "Residential Complex" | "Industrial Park";
  title: string;
  district: string;
  state: string;
  societyId?: string;
  requiredTrade: BlueCollarTrade;
  requiredCount: number;
  startDate: string;
  durationDays: number;
  dailyRatePerWorker: number;
  budgetTotal: number;
  status: "pending_review" | "team_proposed" | "confirmed";
  proposedWorkerIds: string[];
  scopeSummary: string;
}

export interface RateCard {
  id: string;
  category: string;
  serviceName: string;
  trade: BlueCollarTrade;
  baseRateHourly: number;
  overtimeRateHourly: number;
  unit: string;
  cooperativeLevyPercent: number; // e.g. 5% collective fund
  minimumHours: number;
  status: "Draft" | "Active";
  lastUpdated: string;
}

export interface AuditEvent {
  id: string;
  timestamp: string;
  actorName: string;
  actorTier: HierarchyTier;
  actionType:
    | "HIERARCHY_ADD"
    | "SOS_DISPATCH"
    | "SOS_RESOLVE"
    | "RATE_CARD_UPDATE"
    | "BULK_REQUEST_CONFIRM"
    | "RATE_CARD_STATUS_TOGGLE"
    | "FEDERATION_BASE_PRICE_UPDATE"
    | "SOCIETY_TASK_PRICE_UPDATE"
    | "WORKER_DISPATCH_REBALANCE";
  summary: string;
  details: string;
  beforeValue?: string;
  afterValue?: string;
}

export interface NotificationItem {
  id: string;
  type: "sos" | "bulk" | "system" | "audit" | "demand";
  title: string;
  message: string;
  timestamp: string;
  read: boolean;
  linkTarget?: string;
}

export interface DemoAccount {
  id: string;
  tier: HierarchyTier;
  tierLabel: string;
  roleType: "federation" | "society";
  name: string;
  code: string;
  nodeId: string;
  officerName: string;
  designation: string;
  jurisdictionScope: string;
  badgeText: string;
  description: string;
  primaryTrade?: BlueCollarTrade;
  affiliatedSocietiesCount?: number;
  totalMembersCount?: number;
}