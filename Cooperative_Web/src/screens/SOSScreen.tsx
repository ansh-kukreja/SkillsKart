import React, { useState } from "react";
import { useApp } from "../context/AppContext";
import { SOSAlert, Worker } from "../types";
import { Button } from "../components/common/Button";
import { Badge } from "../components/common/Badge";
import { Modal } from "../components/common/Modal";
import { ExportModal } from "../components/common/ExportModal";

export const SOSScreen: React.FC = () => {
  const { scopedSOSAlerts, scopedWorkers, dispatchSOS, resolveSOS } = useApp();

  const [activeTab, setActiveTab] = useState<"all" | "open" | "dispatched" | "resolved">("all");
  const [selectedAlert, setSelectedAlert] = useState<SOSAlert | null>(null);
  const [isDispatchModalOpen, setIsDispatchModalOpen] = useState(false);
  const [isExportOpen, setIsExportOpen] = useState(false);

  // Filter alerts by tab
  const filteredAlerts = scopedSOSAlerts.filter((a) => {
    if (activeTab === "all") return true;
    return a.status === activeTab;
  });

  const openAlertsCount = scopedSOSAlerts.filter((a) => a.status === "open").length;
  const dispatchedAlertsCount = scopedSOSAlerts.filter((a) => a.status === "dispatched").length;
  const resolvedAlertsCount = scopedSOSAlerts.filter((a) => a.status === "resolved").length;

  const handleOpenDispatch = (alert: SOSAlert) => {
    setSelectedAlert(alert);
    setIsDispatchModalOpen(true);
  };

  const handleConfirmDispatch = (workerId: string) => {
    if (!selectedAlert) return;
    dispatchSOS(selectedAlert.id, workerId);
    setIsDispatchModalOpen(false);
    setSelectedAlert(null);
  };

  const handleResolveAlert = (alertId: string) => {
    resolveSOS(alertId);
  };

  // Find eligible nearby relief workers for dispatch (prefer same trade or electrical/safety)
  const nearbyReliefWorkers = selectedAlert
    ? scopedWorkers
        .filter((w) => w.id !== selectedAlert.workerId)
        .slice(0, 5)
    : [];

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-line-hairline">
        <div>
          <div className="flex items-center gap-2 mb-1">
            <span className="text-[10px] uppercase font-bold tracking-widest text-[#C2410C]">
              Emergency Rapid Response
            </span>
            <span className="text-outline">·</span>
            <Badge tone="rust" size="sm">
              Live Mutual Aid
            </Badge>
          </div>
          <h1 className="font-headline text-2xl sm:text-3xl font-semibold text-on-surface tracking-tight">
            Emergency SOS Incident Dispatch
          </h1>
          <p className="font-body text-xs text-on-surface-variant mt-0.5">
            Rapid technician assistance for job-site electrical shocks, mechanical hazards, scaffolding slips, and unlawful wage disputes.
          </p>
        </div>

        <div className="flex items-center gap-2.5">
          <Button
            variant="outlined"
            size="md"
            icon="file_download"
            onClick={() => setIsExportOpen(true)}
          >
            Export Incident Log
          </Button>
        </div>
      </div>

      {/* Tonal Status Metric Strip */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-3.5">
        {/* Open Emergencies */}
        <div className="bg-[#FEF2F2] border border-[#EF4444] p-4 rounded-DEFAULT ledger-offset-shadow space-y-1">
          <div className="flex items-center justify-between">
            <span className="text-[10px] uppercase font-bold tracking-wider text-[#991B1B]">
              Open Unassigned SOS
            </span>
            <span className="material-symbols-outlined text-[#EF4444] text-base animate-pulse">
              e911_emergency
            </span>
          </div>
          <div className="font-headline text-3xl font-bold text-[#991B1B]">
            {openAlertsCount}
          </div>
          <span className="text-[11px] text-[#991B1B]/80 block">
            Requires nearest technician dispatch
          </span>
        </div>

        {/* Dispatched */}
        <div className="bg-[#FEF3C7] border border-[#F59E0B] p-4 rounded-DEFAULT ledger-offset-shadow space-y-1">
          <div className="flex items-center justify-between">
            <span className="text-[10px] uppercase font-bold tracking-wider text-[#92400E]">
              Dispatched / En Route
            </span>
            <span className="material-symbols-outlined text-[#F59E0B] text-base">
              local_shipping
            </span>
          </div>
          <div className="font-headline text-3xl font-bold text-[#92400E]">
            {dispatchedAlertsCount}
          </div>
          <span className="text-[11px] text-[#92400E]/80 block">
            Relief technician on-site
          </span>
        </div>

        {/* Resolved */}
        <div className="bg-[#F2F7EC] border border-[#84CC16] p-4 rounded-DEFAULT ledger-offset-shadow space-y-1">
          <div className="flex items-center justify-between">
            <span className="text-[10px] uppercase font-bold tracking-wider text-[#365314]">
              Resolved Safely
            </span>
            <span className="material-symbols-outlined text-[#84CC16] text-base">
              check_circle
            </span>
          </div>
          <div className="font-headline text-3xl font-bold text-[#365314]">
            {resolvedAlertsCount}
          </div>
          <span className="text-[11px] text-[#365314]/80 block">
            Verified safe by site supervisor
          </span>
        </div>
      </div>

      {/* Tabs */}
      <div className="flex items-center gap-2 border-b border-line-hairline pb-2">
        <button
          onClick={() => setActiveTab("all")}
          className={`px-3 py-1.5 rounded-sm text-xs font-bold transition-colors ${
            activeTab === "all"
              ? "bg-primary-container text-white"
              : "text-on-surface-variant hover:bg-surface-container"
          }`}
        >
          All Incidents ({scopedSOSAlerts.length})
        </button>
        <button
          onClick={() => setActiveTab("open")}
          className={`px-3 py-1.5 rounded-sm text-xs font-bold transition-colors flex items-center gap-1.5 ${
            activeTab === "open"
              ? "bg-[#C2410C] text-white"
              : "text-on-surface-variant hover:bg-surface-container"
          }`}
        >
          <span>Open ({openAlertsCount})</span>
          {openAlertsCount > 0 && (
            <span className="w-2 h-2 rounded-full bg-[#EF4444] animate-ping" />
          )}
        </button>
        <button
          onClick={() => setActiveTab("dispatched")}
          className={`px-3 py-1.5 rounded-sm text-xs font-bold transition-colors ${
            activeTab === "dispatched"
              ? "bg-[#B45309] text-white"
              : "text-on-surface-variant hover:bg-surface-container"
          }`}
        >
          Dispatched ({dispatchedAlertsCount})
        </button>
        <button
          onClick={() => setActiveTab("resolved")}
          className={`px-3 py-1.5 rounded-sm text-xs font-bold transition-colors ${
            activeTab === "resolved"
              ? "bg-[#4D7C0F] text-white"
              : "text-on-surface-variant hover:bg-surface-container"
          }`}
        >
          Resolved ({resolvedAlertsCount})
        </button>
      </div>

      {/* Alerts Cards List */}
      <div className="space-y-3.5">
        {filteredAlerts.length === 0 ? (
          <div className="text-center py-12 bg-surface-container-low border border-line-hairline rounded-DEFAULT text-outline text-xs">
            <span className="material-symbols-outlined text-4xl mb-2 text-outline block">
              verified
            </span>
            <p className="font-headline text-sm font-semibold text-on-surface">
              No incidents in "{activeTab.toUpperCase()}" queue
            </p>
            <p className="text-[11px] text-on-surface-variant mt-0.5">
              All active blue-collar gig workers are operating within nominal safety parameters.
            </p>
          </div>
        ) : (
          filteredAlerts.map((alert) => {
            const isOpen = alert.status === "open";
            const isDispatched = alert.status === "dispatched";
            const isResolved = alert.status === "resolved";

            return (
              <div
                key={alert.id}
                className={`p-4 rounded-DEFAULT border transition-all ${
                  isOpen
                    ? "bg-[#FFFBFB] border-[#EF4444] ledger-offset-shadow"
                    : isDispatched
                    ? "bg-[#FFFDF7] border-[#F59E0B]"
                    : "bg-surface-container-lowest border-line-hairline opacity-90"
                }`}
              >
                <div className="flex flex-col sm:flex-row sm:items-start justify-between gap-3">
                  {/* Left: Incident Identity */}
                  <div className="space-y-1.5">
                    <div className="flex flex-wrap items-center gap-2">
                      <span className="font-mono font-bold text-xs text-on-surface uppercase">
                        #{alert.id.toUpperCase()}
                      </span>

                      <Badge
                        tone={
                          alert.type === "worker_emergency"
                            ? "rust"
                            : alert.type === "technical_safety"
                            ? "terracotta"
                            : "neutral"
                        }
                        size="sm"
                      >
                        {alert.type === "worker_emergency"
                          ? "Medical / Physical Emergency"
                          : alert.type === "technical_safety"
                          ? "Hazard / Equipment Defect"
                          : "Wage Dispute / Harassment"}
                      </Badge>

                      <Badge
                        tone={
                          alert.severity === "critical"
                            ? "rust"
                            : alert.severity === "high"
                            ? "terracotta"
                            : "neutral"
                        }
                        size="sm"
                      >
                        {alert.severity} Severity
                      </Badge>

                      <span className="text-[11px] text-outline">
                        · {alert.timestamp}
                      </span>
                    </div>

                    <div className="flex items-center gap-2">
                      <h3 className="font-headline font-semibold text-sm text-on-surface">
                        {alert.workerName}
                      </h3>
                      <span className="text-xs text-[#B45309] font-bold">
                        ({alert.trade})
                      </span>
                    </div>

                    {/* Location and GPS Coordinates */}
                    <div className="flex items-center gap-1.5 text-xs text-on-surface-variant">
                      <span className="material-symbols-outlined text-sm text-outline">
                        location_on
                      </span>
                      <span>{alert.location}</span>
                      <span className="font-mono text-[10px] text-outline">
                        ({alert.coordinates})
                      </span>
                    </div>

                    {/* Description Note */}
                    <p className="font-body text-xs text-on-surface bg-surface-container-low p-2.5 rounded-sm border border-line-hairline mt-2 leading-relaxed max-w-3xl">
                      <strong className="text-outline uppercase text-[10px] block mb-0.5">
                        Incident Dispatch Log:
                      </strong>
                      {alert.notes}
                    </p>

                    {/* Dispatched Worker Info */}
                    {alert.dispatchedWorkerName && (
                      <div className="flex items-center gap-2 text-xs pt-1 text-on-surface">
                        <span className="material-symbols-outlined text-base text-tertiary">
                          support_agent
                        </span>
                        <span>
                          Assigned Relief: <strong className="text-primary-container">{alert.dispatchedWorkerName}</strong>
                        </span>
                        <span className="text-[11px] text-outline">
                          (Dispatched {alert.dispatchedTimestamp || "recently"})
                        </span>
                      </div>
                    )}
                  </div>

                  {/* Right: Actions */}
                  <div className="flex sm:flex-col items-end justify-between sm:justify-start gap-2 shrink-0">
                    <Badge
                      tone={isOpen ? "rust" : isDispatched ? "terracotta" : "olive"}
                      size="md"
                    >
                      Status: {alert.status}
                    </Badge>

                    {isOpen && (
                      <Button
                        variant="secondary"
                        size="md"
                        icon="send"
                        onClick={() => handleOpenDispatch(alert)}
                      >
                        Dispatch Nearest Worker
                      </Button>
                    )}

                    {isDispatched && (
                      <Button
                        variant="primary"
                        size="md"
                        icon="check_circle"
                        onClick={() => handleResolveAlert(alert.id)}
                      >
                        Confirm Resolved
                      </Button>
                    )}

                    {isResolved && (
                      <span className="text-[10px] font-mono text-tertiary font-bold flex items-center gap-1">
                        <span className="material-symbols-outlined text-sm">done_all</span>
                        Incident Closed
                      </span>
                    )}
                  </div>
                </div>
              </div>
            );
          })
        )}
      </div>

      {/* Dispatch Selection Modal */}
      {isDispatchModalOpen && selectedAlert && (
        <Modal
          isOpen={true}
          onClose={() => setIsDispatchModalOpen(false)}
          title={`Dispatch Relief Technician for #${selectedAlert.id.toUpperCase()}`}
          subtitle={`Incident: ${selectedAlert.workerName} (${selectedAlert.trade}) at ${selectedAlert.location}`}
          maxWidth="lg"
        >
          <div className="space-y-4">
            <div className="p-3 bg-surface-container-low border border-line-hairline rounded-sm text-xs text-on-surface-variant">
              <span className="font-bold text-on-surface block mb-1">
                Mutual Aid Proximity Dispatch:
              </span>
              <span>
                The cooperative protocol ranks nearby enrolled blue-collar workers in the same district cluster with immediate availability to assist.
              </span>
            </div>

            <div className="space-y-2 max-h-72 overflow-y-auto">
              {nearbyReliefWorkers.map((worker) => (
                <div
                  key={worker.id}
                  className="flex items-center justify-between p-3 rounded-sm bg-surface-container-lowest border border-line-hairline hover:border-line-focused transition-all"
                >
                  <div className="flex items-center gap-3">
                    <div className="w-8 h-8 rounded-sm bg-primary-fixed text-on-primary-fixed flex items-center justify-center font-bold text-xs">
                      {worker.name.charAt(0)}
                    </div>
                    <div>
                      <span className="font-bold text-xs text-on-surface block">
                        {worker.name}
                      </span>
                      <span className="text-[11px] text-[#B45309] block">
                        {worker.trade} · {worker.locationCluster}
                      </span>
                    </div>
                  </div>

                  <div className="flex items-center gap-3">
                    <span className="text-[10px] text-tertiary font-mono font-bold">
                      ★ {worker.rating.toFixed(2)}
                    </span>
                    <Button
                      variant="primary"
                      size="sm"
                      icon="arrow_forward"
                      onClick={() => handleConfirmDispatch(worker.id)}
                    >
                      Assign & Dispatch
                    </Button>
                  </div>
                </div>
              ))}
            </div>

            <div className="flex justify-end pt-2">
              <Button
                variant="outlined"
                size="md"
                onClick={() => setIsDispatchModalOpen(false)}
              >
                Cancel
              </Button>
            </div>
          </div>
        </Modal>
      )}

      {/* Export Table Modal */}
      <ExportModal
        isOpen={isExportOpen}
        onClose={() => setIsExportOpen(false)}
        datasetName="Emergency_SOS"
        data={scopedSOSAlerts}
      />
    </div>
  );
};
