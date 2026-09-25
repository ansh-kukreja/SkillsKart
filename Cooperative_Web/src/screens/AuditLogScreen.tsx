import React, { useState } from "react";
import { useApp } from "../context/AppContext";
import { AuditEvent } from "../types";
import { Button } from "../components/common/Button";
import { Badge } from "../components/common/Badge";
import { ExportModal } from "../components/common/ExportModal";

export const AuditLogScreen: React.FC = () => {
  const { auditEvents, currentNode } = useApp();

  const [selectedType, setSelectedType] = useState<string>("ALL");
  const [searchQuery, setSearchQuery] = useState<string>("");
  const [isExportOpen, setIsExportOpen] = useState(false);

  // Filter events
  const filteredEvents = auditEvents.filter((ev) => {
    const matchType =
      selectedType === "ALL" ||
      (selectedType === "HIERARCHY" && ev.actionType === "HIERARCHY_ADD") ||
      (selectedType === "SOS" && (ev.actionType === "SOS_DISPATCH" || ev.actionType === "SOS_RESOLVE")) ||
      (selectedType === "RATE" && (ev.actionType === "RATE_CARD_UPDATE" || ev.actionType === "RATE_CARD_STATUS_TOGGLE")) ||
      (selectedType === "BULK" && ev.actionType === "BULK_REQUEST_CONFIRM");

    const matchSearch =
      ev.summary.toLowerCase().includes(searchQuery.toLowerCase()) ||
      ev.details.toLowerCase().includes(searchQuery.toLowerCase()) ||
      ev.actorName.toLowerCase().includes(searchQuery.toLowerCase());

    return matchType && matchSearch;
  });

  const getActionBadge = (type: AuditEvent["actionType"]) => {
    switch (type) {
      case "HIERARCHY_ADD":
        return <Badge tone="olive" size="sm">Hierarchy Enroll</Badge>;
      case "SOS_DISPATCH":
        return <Badge tone="rust" size="sm">SOS Dispatch</Badge>;
      case "SOS_RESOLVE":
        return <Badge tone="olive" size="sm">SOS Resolved</Badge>;
      case "RATE_CARD_UPDATE":
        return <Badge tone="terracotta" size="sm">Tariff Update</Badge>;
      case "RATE_CARD_STATUS_TOGGLE":
        return <Badge tone="neutral" size="sm">Status Toggle</Badge>;
      case "BULK_REQUEST_CONFIRM":
        return <Badge tone="olive" size="sm">Tender Confirmed</Badge>;
      default:
        return <Badge tone="neutral" size="sm">{type}</Badge>;
    }
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-line-hairline">
        <div>
          <div className="flex items-center gap-2 mb-1">
            <span className="text-[10px] uppercase font-bold tracking-widest text-[#B45309]">
              Cryptographic Audit Trail
            </span>
            <span className="text-outline">·</span>
            <Badge tone="olive" size="sm">
              Tamper-Evident Ledger
            </Badge>
          </div>
          <h1 className="font-headline text-2xl sm:text-3xl font-semibold text-on-surface tracking-tight">
            Administrative Audit Ledger
          </h1>
          <p className="font-body text-xs text-on-surface-variant mt-0.5">
            Immutable log of all state-changing actions performed in this session across hierarchy enrollment, SOS dispatches, tariff adjustments, and bulk contracts.
          </p>
        </div>

        <div className="flex items-center gap-2.5">
          <Button
            variant="outlined"
            size="md"
            icon="file_download"
            onClick={() => setIsExportOpen(true)}
          >
            Export Audit Trail ({filteredEvents.length})
          </Button>
        </div>
      </div>

      {/* Filter and Search Bar */}
      <div className="bg-surface-container-lowest border border-line-hairline p-4 rounded-DEFAULT ledger-offset-shadow flex flex-col sm:flex-row items-center justify-between gap-3 text-xs">
        <div className="flex flex-wrap items-center gap-2 w-full sm:w-auto">
          <span className="font-bold uppercase tracking-wider text-outline text-[10px] mr-1">
            Filter Action:
          </span>
          {["ALL", "HIERARCHY", "SOS", "RATE", "BULK"].map((type) => (
            <button
              key={type}
              onClick={() => setSelectedType(type)}
              className={`px-2.5 py-1 rounded-sm text-xs font-bold transition-colors ${
                selectedType === type
                  ? "bg-primary-container text-white"
                  : "bg-surface-container-low text-on-surface-variant hover:bg-surface-container"
              }`}
            >
              {type === "ALL"
                ? "All Events"
                : type === "HIERARCHY"
                ? "Hierarchy"
                : type === "SOS"
                ? "Emergency SOS"
                : type === "RATE"
                ? "Tariff Changes"
                : "Tender Confirms"}
            </button>
          ))}
        </div>

        <div className="relative w-full sm:w-64">
          <span className="material-symbols-outlined absolute left-2.5 top-1/2 -translate-y-1/2 text-outline text-sm">
            search
          </span>
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder="Search by actor, action, details..."
            className="w-full bg-surface-container-low border border-line-focused pl-8 pr-3 py-1.5 rounded-sm text-xs font-body text-on-surface placeholder:text-outline focus:outline-none focus:border-primary"
          />
        </div>
      </div>

      {/* Audit Table */}
      <div className="bg-surface-container-lowest border border-line-hairline rounded-DEFAULT ledger-offset-shadow overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse text-xs">
            <thead>
              <tr className="bg-surface-container-high border-b border-line-hairline text-[10px] uppercase tracking-wider text-outline font-bold">
                <th className="py-2.5 px-3">Timestamp / Ref</th>
                <th className="py-2.5 px-3">Authorized Actor</th>
                <th className="py-2.5 px-3">Action Type</th>
                <th className="py-2.5 px-3">Ledger Event Summary</th>
                <th className="py-2.5 px-3">State Transition (Before → After)</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-line-hairline">
              {filteredEvents.length === 0 ? (
                <tr>
                  <td colSpan={5} className="text-center py-10 text-outline text-xs">
                    No audit records match the current filter.
                  </td>
                </tr>
              ) : (
                filteredEvents.map((ev) => (
                  <tr key={ev.id} className="hover:bg-surface-container-low transition-colors">
                    <td className="py-3 px-3 font-mono text-[11px]">
                      <span className="font-bold text-on-surface block">{ev.timestamp}</span>
                      <span className="text-[10px] text-outline uppercase">{ev.id}</span>
                    </td>

                    <td className="py-3 px-3">
                      <span className="font-bold text-on-surface block">{ev.actorName}</span>
                      <span className="text-[10px] text-outline uppercase font-mono">
                        Tier: {ev.actorTier}
                      </span>
                    </td>

                    <td className="py-3 px-3">
                      {getActionBadge(ev.actionType)}
                    </td>

                    <td className="py-3 px-3 max-w-sm">
                      <span className="font-bold text-on-surface block">{ev.summary}</span>
                      <p className="text-[11px] text-on-surface-variant leading-snug mt-0.5 line-clamp-2">
                        {ev.details}
                      </p>
                    </td>

                    <td className="py-3 px-3 font-mono text-[11px]">
                      {ev.beforeValue && ev.afterValue ? (
                        <div className="bg-surface-container-low px-2 py-1 rounded border border-line-hairline flex items-center gap-1.5 whitespace-nowrap">
                          <span className="text-outline">{ev.beforeValue}</span>
                          <span className="text-primary-container font-bold">→</span>
                          <span className="text-tertiary font-bold">{ev.afterValue}</span>
                        </div>
                      ) : (
                        <span className="text-outline text-[11px] italic">Initial State Created</span>
                      )}
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Export Table Modal */}
      <ExportModal
        isOpen={isExportOpen}
        onClose={() => setIsExportOpen(false)}
        datasetName="Audit_Log"
        data={filteredEvents}
      />
    </div>
  );
};
