import React, { useState } from "react";
import { useApp } from "../context/AppContext";
import { BulkRequest, Worker } from "../types";
import { Button } from "../components/common/Button";
import { Badge } from "../components/common/Badge";
import { Modal } from "../components/common/Modal";
import { ExportModal } from "../components/common/ExportModal";

export const BulkRequestsScreen: React.FC = () => {
  const {
    scopedBulkRequests,
    scopedWorkers,
    proposeBulkTeam,
    confirmBulkRequest,
  } = useApp();

  const [selectedRequest, setSelectedRequest] = useState<BulkRequest | null>(null);
  const [selectedWorkerIds, setSelectedWorkerIds] = useState<string[]>([]);
  const [isProposeModalOpen, setIsProposeModalOpen] = useState(false);
  const [isExportOpen, setIsExportOpen] = useState(false);

  // Capacity check helper for a given trade
  const getAvailableCapacity = (trade: string) => {
    return scopedWorkers.filter(
      (w) => w.trade === trade && w.currentAvailability === "Available"
    ).length;
  };

  const handleOpenProposeTeam = (req: BulkRequest) => {
    setSelectedRequest(req);
    // Pre-select available workers of that trade
    const eligible = scopedWorkers
      .filter((w) => w.trade === req.requiredTrade)
      .map((w) => w.id)
      .slice(0, req.requiredCount);
    setSelectedWorkerIds(eligible);
    setIsProposeModalOpen(true);
  };

  const handleToggleWorker = (workerId: string) => {
    if (selectedWorkerIds.includes(workerId)) {
      setSelectedWorkerIds((prev) => prev.filter((id) => id !== workerId));
    } else {
      if (selectedRequest && selectedWorkerIds.length < selectedRequest.requiredCount) {
        setSelectedWorkerIds((prev) => [...prev, workerId]);
      }
    }
  };

  const handleConfirmPropose = () => {
    if (!selectedRequest) return;
    proposeBulkTeam(selectedRequest.id, selectedWorkerIds);
    setIsProposeModalOpen(false);
    setSelectedRequest(null);
  };

  const handleFinalConfirm = (requestId: string) => {
    confirmBulkRequest(requestId);
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-line-hairline">
        <div>
          <div className="flex items-center gap-2 mb-1">
            <span className="text-[10px] uppercase font-bold tracking-widest text-[#B45309]">
              Institutional Market Hub
            </span>
            <span className="text-outline">·</span>
            <Badge tone="olive" size="sm">
              Collective Tenders
            </Badge>
          </div>
          <h1 className="font-headline text-2xl sm:text-3xl font-semibold text-on-surface tracking-tight">
            Bulk & Institutional Service Contracts
          </h1>
          <p className="font-body text-xs text-on-surface-variant mt-0.5">
            Multi-worker tender pipeline for municipal corporations, transit authorities, industrial estates, and housing societies.
          </p>
        </div>

        <div className="flex items-center gap-2.5">
          <Button
            variant="outlined"
            size="md"
            icon="file_download"
            onClick={() => setIsExportOpen(true)}
          >
            Export Contracts
          </Button>
        </div>
      </div>

      {/* Requests Grid */}
      <div className="space-y-4">
        {scopedBulkRequests.map((req) => {
          const availableCapacity = getAvailableCapacity(req.requiredTrade);
          const hasSufficientCapacity = availableCapacity >= req.requiredCount;
          const isPending = req.status === "pending_review";
          const isProposed = req.status === "team_proposed";
          const isConfirmed = req.status === "confirmed";

          return (
            <div
              key={req.id}
              className="bg-surface-container-lowest border border-line-hairline rounded-DEFAULT p-5 ledger-offset-shadow space-y-4"
            >
              {/* Top Row: Client & Title */}
              <div className="flex flex-col sm:flex-row sm:items-start justify-between gap-3 border-b border-line-hairline pb-3">
                <div className="space-y-1">
                  <div className="flex flex-wrap items-center gap-2">
                    <span className="font-mono text-xs font-bold text-outline uppercase">
                      #{req.id.toUpperCase()}
                    </span>
                    <Badge tone="neutral" size="sm">
                      {req.clientType}
                    </Badge>
                    <span className="text-xs text-outline font-body">
                      · Starts {req.startDate} ({req.durationDays} Days Duration)
                    </span>
                  </div>
                  <h3 className="font-headline text-lg font-semibold text-on-surface">
                    {req.title}
                  </h3>
                  <span className="text-xs text-[#B45309] font-bold block">
                    Institutional Client: {req.clientName}
                  </span>
                </div>

                <div className="flex flex-col sm:items-end gap-1.5 shrink-0">
                  <Badge
                    tone={
                      isConfirmed ? "olive" : isProposed ? "terracotta" : "neutral"
                    }
                    size="md"
                  >
                    {req.status === "pending_review"
                      ? "Pending Review"
                      : req.status === "team_proposed"
                      ? "Team Proposed"
                      : "Confirmed Order"}
                  </Badge>
                  <div className="font-headline text-lg font-bold text-on-surface">
                    ₹{req.budgetTotal.toLocaleString("en-IN")}
                  </div>
                  <span className="text-[10px] text-outline font-mono">
                    ₹{req.dailyRatePerWorker}/day per technician
                  </span>
                </div>
              </div>

              {/* Middle Row: Scope & Capacity Check */}
              <div className="grid grid-cols-1 md:grid-cols-12 gap-4 text-xs">
                <div className="md:col-span-8 bg-surface-container-low p-3 rounded-sm border border-line-hairline space-y-1.5">
                  <span className="font-bold uppercase tracking-wider text-outline text-[10px] block">
                    Scope of Operations:
                  </span>
                  <p className="text-on-surface-variant leading-relaxed">
                    {req.scopeSummary}
                  </p>
                </div>

                {/* Capacity Check Badge */}
                <div className="md:col-span-4 bg-surface-container-low p-3 rounded-sm border border-line-hairline flex flex-col justify-between space-y-2">
                  <div>
                    <span className="font-bold uppercase tracking-wider text-outline text-[10px] block mb-1">
                      Local Capacity Audit
                    </span>
                    <div className="flex items-center gap-1.5">
                      <span className="font-bold text-on-surface">
                        Requires: {req.requiredCount} {req.requiredTrade}
                      </span>
                    </div>
                  </div>

                  <div className="pt-2 border-t border-line-hairline flex items-center justify-between">
                    <span className="text-[11px] text-outline">
                      Available: <strong className="text-on-surface">{availableCapacity}</strong>
                    </span>
                    <Badge
                      tone={hasSufficientCapacity ? "olive" : "rust"}
                      size="sm"
                    >
                      {hasSufficientCapacity ? "Capacity Available" : "Tight Capacity"}
                    </Badge>
                  </div>
                </div>
              </div>

              {/* Proposed Workers Chips if available */}
              {req.proposedWorkerIds.length > 0 && (
                <div className="p-3 bg-[#FFFDF7] border border-[#F59E0B] rounded-sm space-y-1 text-xs">
                  <span className="font-bold text-[#92400E] text-[11px] block">
                    Selected Taskforce Roster ({req.proposedWorkerIds.length} Technicians Assigned):
                  </span>
                  <div className="flex flex-wrap gap-1.5 pt-1">
                    {req.proposedWorkerIds.map((id) => {
                      const worker = scopedWorkers.find((w) => w.id === id);
                      return (
                        <span
                          key={id}
                          className="bg-white border border-line-hairline px-2 py-0.5 rounded text-[11px] font-semibold text-on-surface flex items-center gap-1"
                        >
                          <span className="material-symbols-outlined text-xs text-tertiary">check</span>
                          {worker ? worker.name : id}
                        </span>
                      );
                    })}
                  </div>
                </div>
              )}

              {/* Actions */}
              <div className="flex items-center justify-between pt-2 border-t border-line-hairline text-xs">
                <span className="text-outline">
                  Location: <strong className="text-on-surface">{req.district} District Cluster</strong>
                </span>

                <div className="flex items-center gap-2">
                  {isPending && (
                    <Button
                      variant="primary"
                      size="md"
                      icon="group_add"
                      onClick={() => handleOpenProposeTeam(req)}
                    >
                      Propose Team ({req.requiredCount} Workers)
                    </Button>
                  )}

                  {isProposed && (
                    <>
                      <Button
                        variant="outlined"
                        size="md"
                        icon="edit"
                        onClick={() => handleOpenProposeTeam(req)}
                      >
                        Adjust Team
                      </Button>
                      <Button
                        variant="primary"
                        size="md"
                        icon="verified"
                        onClick={() => handleFinalConfirm(req.id)}
                      >
                        Confirm & Seal Tender
                      </Button>
                    </>
                  )}

                  {isConfirmed && (
                    <span className="text-tertiary font-bold flex items-center gap-1 font-mono text-xs">
                      <span className="material-symbols-outlined text-base">task_alt</span>
                      Deployment Active & Sealed
                    </span>
                  )}
                </div>
              </div>
            </div>
          );
        })}
      </div>

      {/* Propose Team Modal */}
      {isProposeModalOpen && selectedRequest && (
        <Modal
          isOpen={true}
          onClose={() => setIsProposeModalOpen(false)}
          title={`Assemble Team for: ${selectedRequest.title}`}
          subtitle={`Required: ${selectedRequest.requiredCount} Technicians (${selectedRequest.requiredTrade}) · Rate: ₹${selectedRequest.dailyRatePerWorker}/day`}
          maxWidth="lg"
        >
          <div className="space-y-4">
            <div className="flex items-center justify-between p-3 bg-surface-container-low border border-line-hairline rounded-sm text-xs">
              <span>
                Selected: <strong className="text-primary-container">{selectedWorkerIds.length}</strong> of {selectedRequest.requiredCount} required
              </span>
              <Badge
                tone={selectedWorkerIds.length === selectedRequest.requiredCount ? "olive" : "terracotta"}
                size="sm"
              >
                {selectedWorkerIds.length === selectedRequest.requiredCount ? "Quota Full" : "Slots Remaining"}
              </Badge>
            </div>

            <div className="space-y-2 max-h-72 overflow-y-auto">
              {scopedWorkers
                .filter((w) => w.trade === selectedRequest.requiredTrade)
                .map((worker) => {
                  const isChecked = selectedWorkerIds.includes(worker.id);
                  return (
                    <div
                      key={worker.id}
                      onClick={() => handleToggleWorker(worker.id)}
                      className={`flex items-center justify-between p-3 rounded-sm border cursor-pointer transition-all ${
                        isChecked
                          ? "bg-[#FFFDF7] border-[#B45309]"
                          : "bg-surface-container-lowest border-line-hairline hover:border-line-focused"
                      }`}
                    >
                      <div className="flex items-center gap-3">
                        <input
                          type="checkbox"
                          checked={isChecked}
                          onChange={() => {}}
                          className="rounded border-outline-variant text-primary-container focus:ring-primary-container cursor-pointer"
                        />
                        <div>
                          <span className="font-bold text-xs text-on-surface block">
                            {worker.name}
                          </span>
                          <span className="text-[11px] text-outline">
                            Exp: {worker.experienceYears} Yrs · {worker.locationCluster} · ★ {worker.rating.toFixed(2)}
                          </span>
                        </div>
                      </div>

                      <Badge
                        tone={worker.currentAvailability === "Available" ? "olive" : "neutral"}
                        size="sm"
                      >
                        {worker.currentAvailability}
                      </Badge>
                    </div>
                  );
                })}
            </div>

            <div className="flex justify-end gap-2 pt-2">
              <Button
                variant="outlined"
                size="md"
                onClick={() => setIsProposeModalOpen(false)}
              >
                Cancel
              </Button>
              <Button
                variant="primary"
                size="md"
                icon="check"
                disabled={selectedWorkerIds.length === 0}
                onClick={handleConfirmPropose}
              >
                Propose Team ({selectedWorkerIds.length} Selected)
              </Button>
            </div>
          </div>
        </Modal>
      )}

      {/* Export Table Modal */}
      <ExportModal
        isOpen={isExportOpen}
        onClose={() => setIsExportOpen(false)}
        datasetName="Bulk_Requests"
        data={scopedBulkRequests}
      />
    </div>
  );
};
