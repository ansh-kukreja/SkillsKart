import React, { useState, useMemo } from "react";
import { useSearchParams } from "react-router-dom";
import { useApp } from "../context/AppContext";
import { Worker, BlueCollarTrade } from "../types";
import { Button } from "../components/common/Button";
import { Badge } from "../components/common/Badge";
import { Modal } from "../components/common/Modal";
import { ExportModal } from "../components/common/ExportModal";

const TRADE_LIST: string[] = [
  "All Trades",
  "Plumbing & Sanitation",
  "Electrical & Wiring",
  "Gardening & Landscaping",
  "Caregiving & Elder Care",
  "Appliance Repair & HVAC",
  "Carpentry & Woodwork",
  "Painting & Waterproofing",
  "Housekeeping & Domestic Help",
  "Facility Cleaning & Pest Control",
];

export const DirectoryScreen: React.FC = () => {
  const { scopedWorkers, scopedSocieties } = useApp();
  const [searchParams, setSearchParams] = useSearchParams();

  const [selectedTrade, setSelectedTrade] = useState<string>("All Trades");
  const [selectedAvailability, setSelectedAvailability] = useState<string>("All");
  const [searchQuery, setSearchQuery] = useState<string>("");
  const [isExportOpen, setIsExportOpen] = useState(false);

  // Selected worker for detail drawer
  const workerParamId = searchParams.get("workerId");
  const [activeWorker, setActiveWorker] = useState<Worker | null>(() => {
    if (workerParamId) {
      return scopedWorkers.find((w) => w.id === workerParamId) || null;
    }
    return null;
  });

  // Multi-Filter Logic
  const filteredWorkers = useMemo(() => {
    return scopedWorkers.filter((w) => {
      const matchSearch =
        w.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
        w.phone.includes(searchQuery) ||
        w.locationCluster.toLowerCase().includes(searchQuery.toLowerCase()) ||
        w.id.toLowerCase().includes(searchQuery.toLowerCase());

      const matchTrade =
        selectedTrade === "All Trades" || w.trade === selectedTrade;

      const matchAvailability =
        selectedAvailability === "All" || w.currentAvailability === selectedAvailability;

      return matchSearch && matchTrade && matchAvailability;
    });
  }, [scopedWorkers, searchQuery, selectedTrade, selectedAvailability]);

  const handleOpenDetail = (worker: Worker) => {
    setActiveWorker(worker);
    setSearchParams({ workerId: worker.id });
  };

  const handleCloseDetail = () => {
    setActiveWorker(null);
    setSearchParams({});
  };

  // Find society name helper
  const getSocietyName = (socId: string) => {
    const soc = scopedSocieties.find((s) => s.id === socId);
    return soc ? soc.name : socId;
  };

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-line-hairline">
        <div>
          <div className="flex items-center gap-2 mb-1">
            <span className="text-[10px] uppercase font-bold tracking-widest text-[#B45309]">
              Workforce Ledger
            </span>
            <span className="text-outline">·</span>
            <Badge tone="olive" size="sm">
              Direct Active Roster
            </Badge>
          </div>
          <h1 className="font-headline text-2xl sm:text-3xl font-semibold text-on-surface tracking-tight">
            Blue-Collar Technician Directory
          </h1>
          <p className="font-body text-xs text-on-surface-variant mt-0.5">
            Active trade registry of verified gig technicians across local societies. Zero verification friction.
          </p>
        </div>

        <div className="flex items-center gap-2.5">
          <Button
            variant="outlined"
            size="md"
            icon="file_download"
            onClick={() => setIsExportOpen(true)}
          >
            Export Roster ({filteredWorkers.length})
          </Button>
        </div>
      </div>

      {/* Filter Toolbar */}
      <div className="bg-surface-container-lowest border border-line-hairline p-4 rounded-DEFAULT ledger-offset-shadow space-y-3">
        <div className="grid grid-cols-1 sm:grid-cols-3 lg:grid-cols-4 gap-3">
          {/* Search Input */}
          <div className="sm:col-span-2 relative">
            <span className="material-symbols-outlined absolute left-2.5 top-1/2 -translate-y-1/2 text-outline text-sm">
              search
            </span>
            <input
              type="text"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder="Search by worker name, phone, UID, or cluster..."
              className="w-full bg-surface-container-low border border-line-focused pl-8 pr-3 py-1.5 rounded-sm text-xs font-body text-on-surface placeholder:text-outline focus:outline-none focus:border-primary"
            />
          </div>

          {/* Trade Filter Dropdown */}
          <div>
            <select
              value={selectedTrade}
              onChange={(e) => setSelectedTrade(e.target.value)}
              className="w-full bg-surface-container-low border border-line-focused px-3 py-1.5 rounded-sm text-xs font-body text-on-surface focus:outline-none focus:border-primary"
            >
              {TRADE_LIST.map((t) => (
                <option key={t} value={t}>
                  {t}
                </option>
              ))}
            </select>
          </div>

          {/* Availability Status */}
          <div>
            <select
              value={selectedAvailability}
              onChange={(e) => setSelectedAvailability(e.target.value)}
              className="w-full bg-surface-container-low border border-line-focused px-3 py-1.5 rounded-sm text-xs font-body text-on-surface focus:outline-none focus:border-primary"
            >
              <option value="All">All Availability States</option>
              <option value="Available">Available for Dispatch</option>
              <option value="On-Job">Currently On-Job</option>
              <option value="Off-Duty">Off-Duty / Rest</option>
            </select>
          </div>
        </div>

        {/* Quick Filter Chips Summary */}
        <div className="flex items-center justify-between text-xs pt-2 border-t border-line-hairline text-outline">
          <span>
            Showing <strong className="text-on-surface">{filteredWorkers.length}</strong> of {scopedWorkers.length} active technicians
          </span>
          {(searchQuery || selectedTrade !== "All Trades" || selectedAvailability !== "All") && (
            <button
              onClick={() => {
                setSearchQuery("");
                setSelectedTrade("All Trades");
                setSelectedAvailability("All");
              }}
              className="text-primary hover:underline text-[11px] font-bold"
            >
              Reset Filters
            </button>
          )}
        </div>
      </div>

      {/* Workers Roster Table */}
      <div className="bg-surface-container-lowest border border-line-hairline rounded-DEFAULT ledger-offset-shadow overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse text-xs">
            <thead>
              <tr className="bg-surface-container-high border-b border-line-hairline text-[10px] uppercase tracking-wider text-outline font-bold">
                <th className="py-2.5 px-3">Technician Details</th>
                <th className="py-2.5 px-3">Primary Trade</th>
                <th className="py-2.5 px-3">Society Affiliation</th>
                <th className="py-2.5 px-3">Field Cluster</th>
                <th className="py-2.5 px-3">Jobs Done</th>
                <th className="py-2.5 px-3">Gross Earnings</th>
                <th className="py-2.5 px-3">Status</th>
                <th className="py-2.5 px-3 text-right">Action</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-line-hairline">
              {filteredWorkers.length === 0 ? (
                <tr>
                  <td colSpan={8} className="text-center py-10 text-outline text-xs">
                    No technicians found matching the selected criteria.
                  </td>
                </tr>
              ) : (
                filteredWorkers.map((worker) => (
                  <tr
                    key={worker.id}
                    onClick={() => handleOpenDetail(worker)}
                    className="hover:bg-surface-container-low cursor-pointer transition-colors"
                  >
                    <td className="py-2.5 px-3">
                      <div className="flex items-center gap-2.5">
                        <div className="w-8 h-8 rounded-sm bg-primary-fixed text-on-primary-fixed flex items-center justify-center font-bold text-xs shrink-0">
                          {worker.name.charAt(0)}
                        </div>
                        <div>
                          <span className="font-bold text-on-surface block leading-tight">
                            {worker.name}
                          </span>
                          <span className="font-mono text-[10px] text-outline">
                            {worker.id} · {worker.phone}
                          </span>
                        </div>
                      </div>
                    </td>

                    <td className="py-2.5 px-3">
                      <span className="font-bold text-[#B45309] block">
                        {worker.trade}
                      </span>
                      <span className="text-[10px] text-outline font-mono">
                        Exp: {worker.experienceYears} Years
                      </span>
                    </td>

                    <td className="py-2.5 px-3">
                      <span className="text-on-surface font-semibold block truncate max-w-[180px]">
                        {getSocietyName(worker.societyId)}
                      </span>
                      <span className="text-[10px] text-outline">
                        {worker.district} District
                      </span>
                    </td>

                    <td className="py-2.5 px-3 text-on-surface-variant">
                      {worker.locationCluster}
                    </td>

                    <td className="py-2.5 px-3 font-mono font-bold text-on-surface">
                      {worker.jobsCompleted}
                    </td>

                    <td className="py-2.5 px-3 font-mono font-semibold text-tertiary">
                      ₹{worker.totalEarnings.toLocaleString("en-IN")}
                    </td>

                    <td className="py-2.5 px-3">
                      <Badge
                        tone={
                          worker.currentAvailability === "Available"
                            ? "olive"
                            : worker.currentAvailability === "On-Job"
                            ? "terracotta"
                            : "neutral"
                        }
                        size="sm"
                      >
                        {worker.currentAvailability}
                      </Badge>
                    </td>

                    <td className="py-2.5 px-3 text-right">
                      <Button
                        variant="outlined"
                        size="sm"
                        icon="visibility"
                        onClick={(e) => {
                          e.stopPropagation();
                          handleOpenDetail(worker);
                        }}
                      >
                        Profile
                      </Button>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Worker Detail Modal / Drawer */}
      {activeWorker && (
        <Modal
          isOpen={true}
          onClose={handleCloseDetail}
          title={`Technician Profile: ${activeWorker.name}`}
          subtitle={`UID: ${activeWorker.id} · Enrolled under ${getSocietyName(activeWorker.societyId)}`}
          maxWidth="xl"
        >
          <div className="space-y-4">
            {/* Top Identity Strip */}
            <div className="p-4 bg-surface-container-low border border-line-hairline rounded-sm flex items-center justify-between gap-3">
              <div className="flex items-center gap-3">
                <div className="w-12 h-12 rounded-sm bg-primary-container text-white flex items-center justify-center font-headline text-xl font-bold border border-[#92400E]">
                  {activeWorker.name.charAt(0)}
                </div>
                <div>
                  <h3 className="font-headline font-semibold text-base text-on-surface">
                    {activeWorker.name}
                  </h3>
                  <div className="flex items-center gap-2 mt-0.5">
                    <span className="font-bold text-xs text-[#B45309]">
                      {activeWorker.trade}
                    </span>
                    <span className="text-outline">·</span>
                    <span className="text-xs text-outline font-mono">
                      Exp: {activeWorker.experienceYears} Years
                    </span>
                  </div>
                </div>
              </div>

              <div className="text-right">
                <Badge
                  tone={
                    activeWorker.currentAvailability === "Available"
                      ? "olive"
                      : activeWorker.currentAvailability === "On-Job"
                      ? "terracotta"
                      : "neutral"
                  }
                  size="md"
                >
                  {activeWorker.currentAvailability}
                </Badge>
                <div className="text-[11px] font-mono font-bold text-tertiary mt-1">
                  ★ {activeWorker.rating.toFixed(2)} Rating
                </div>
              </div>
            </div>

            {/* Performance Summary Matrix */}
            <div className="grid grid-cols-3 gap-3">
              <div className="p-3 bg-surface-container-lowest border border-line-hairline rounded-sm text-center">
                <span className="text-[10px] uppercase font-bold text-outline block">
                  Completed Jobs
                </span>
                <span className="font-headline text-2xl font-bold text-on-surface mt-0.5 block">
                  {activeWorker.jobsCompleted}
                </span>
                <span className="text-[10px] text-tertiary font-bold">100% Resolved</span>
              </div>

              <div className="p-3 bg-surface-container-lowest border border-line-hairline rounded-sm text-center">
                <span className="text-[10px] uppercase font-bold text-outline block">
                  Gross Earnings
                </span>
                <span className="font-headline text-2xl font-bold text-tertiary mt-0.5 block">
                  ₹{(activeWorker.totalEarnings / 1000).toFixed(0)}k
                </span>
                <span className="text-[10px] text-outline">Provident Deducted</span>
              </div>

              <div className="p-3 bg-surface-container-lowest border border-line-hairline rounded-sm text-center">
                <span className="text-[10px] uppercase font-bold text-outline block">
                  Provident Vault
                </span>
                <span className="font-headline text-2xl font-bold text-[#B45309] mt-0.5 block">
                  ₹{Math.round(activeWorker.totalEarnings * 0.05).toLocaleString("en-IN")}
                </span>
                <span className="text-[10px] text-outline">5% Cooperative Reserve</span>
              </div>
            </div>

            {/* Verified Operational Coordinates */}
            <div className="space-y-2 pt-2 border-t border-line-hairline text-xs">
              <span className="font-bold uppercase tracking-wider text-outline text-[11px] block">
                Deployment & Contact Information
              </span>

              <div className="grid grid-cols-2 gap-3 bg-surface-container-low p-3 rounded-sm border border-line-hairline">
                <div>
                  <span className="text-outline text-[10px] uppercase font-bold block">Mobile Contact:</span>
                  <span className="font-mono font-bold text-on-surface">{activeWorker.phone}</span>
                </div>
                <div>
                  <span className="text-outline text-[10px] uppercase font-bold block">Internal Cooperative Email:</span>
                  <span className="font-mono text-on-surface truncate block">{activeWorker.email}</span>
                </div>
                <div>
                  <span className="text-outline text-[10px] uppercase font-bold block">Primary Society:</span>
                  <span className="font-semibold text-on-surface truncate block">
                    {getSocietyName(activeWorker.societyId)}
                  </span>
                </div>
                <div>
                  <span className="text-outline text-[10px] uppercase font-bold block">Assigned Cluster:</span>
                  <span className="font-semibold text-on-surface block">
                    {activeWorker.locationCluster} ({activeWorker.district})
                  </span>
                </div>
              </div>
            </div>

            <div className="flex justify-end pt-2">
              <Button variant="primary" size="md" onClick={handleCloseDetail}>
                Done Viewing
              </Button>
            </div>
          </div>
        </Modal>
      )}

      {/* Export Table Modal */}
      <ExportModal
        isOpen={isExportOpen}
        onClose={() => setIsExportOpen(false)}
        datasetName="Workers"
        data={filteredWorkers}
      />
    </div>
  );
};
