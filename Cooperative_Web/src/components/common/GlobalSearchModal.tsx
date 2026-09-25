import React, { useState, useEffect } from "react";
import { Modal } from "./Modal";
import { Badge } from "./Badge";
import { useApp } from "../../context/AppContext";

interface GlobalSearchModalProps {
  isOpen: boolean;
  onClose: () => void;
  onNavigate: (path: string) => void;
}

export const GlobalSearchModal: React.FC<GlobalSearchModalProps> = ({
  isOpen,
  onClose,
  onNavigate,
}) => {
  const { searchGlobal } = useApp();
  const [query, setQuery] = useState("");

  useEffect(() => {
    if (!isOpen) {
      setQuery("");
    }
  }, [isOpen]);

  const results = searchGlobal(query);
  const totalMatches =
    results.workers.length +
    results.societies.length +
    results.bulkRequests.length +
    results.sosAlerts.length;

  const handleSelect = (path: string) => {
    onNavigate(path);
    onClose();
  };

  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title="Federation Global Search"
      subtitle="Query workers, primary societies, institutional tenders, and emergency SOS alerts"
      maxWidth="xl"
    >
      <div className="space-y-4">
        {/* Search input */}
        <div className="relative">
          <span className="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline text-lg">
            search
          </span>
          <input
            type="text"
            autoFocus
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder="Type technician name, phone, trade, society, tender, or SOS case..."
            className="w-full bg-surface-container-low border border-line-focused pl-10 pr-4 py-2.5 rounded-DEFAULT text-sm font-body text-on-surface placeholder:text-outline focus:outline-none focus:border-primary-container focus:ring-1 focus:ring-primary-container"
          />
          {query && (
            <button
              onClick={() => setQuery("")}
              className="absolute right-3 top-1/2 -translate-y-1/2 text-outline hover:text-on-surface text-xs"
            >
              Clear
            </button>
          )}
        </div>

        {/* Results area */}
        <div className="max-h-80 overflow-y-auto space-y-4 pt-1">
          {query.trim() === "" ? (
            <div className="text-center py-8 text-on-surface-variant text-xs">
              <span className="material-symbols-outlined text-3xl text-outline mb-2 block">
                manage_search
              </span>
              <p className="font-semibold text-on-surface">Search the Cooperative Ledger</p>
              <p className="text-[11px] text-outline mt-1">
                Try searching for: <span className="underline cursor-pointer" onClick={() => setQuery("Electrical")}>Electrical</span>,{" "}
                <span className="underline cursor-pointer" onClick={() => setQuery("Rajesh")}>Rajesh</span>,{" "}
                <span className="underline cursor-pointer" onClick={() => setQuery("Haveli")}>Haveli</span>, or{" "}
                <span className="underline cursor-pointer" onClick={() => setQuery("Dispute")}>Dispute</span>
              </p>
            </div>
          ) : totalMatches === 0 ? (
            <div className="text-center py-8 text-on-surface-variant text-xs">
              <span className="material-symbols-outlined text-3xl text-outline mb-2 block">
                search_off
              </span>
              <p className="font-semibold text-on-surface">No records matching "{query}"</p>
              <p className="text-[11px] text-outline mt-1">
                Try searching with a broader keyword or trade name.
              </p>
            </div>
          ) : (
            <>
              {/* Workers */}
              {results.workers.length > 0 && (
                <div>
                  <div className="flex items-center justify-between text-[11px] font-bold uppercase tracking-wider text-outline mb-1.5 pb-1 border-b border-line-hairline">
                    <span>Blue-Collar Workers ({results.workers.length})</span>
                    <span className="text-[10px] text-tertiary">Direct Active Registry</span>
                  </div>
                  <div className="space-y-1.5">
                    {results.workers.map((w) => (
                      <div
                        key={w.id}
                        onClick={() => handleSelect(`/directory?workerId=${w.id}`)}
                        className="flex items-center justify-between p-2 rounded-sm bg-surface-container-low hover:bg-surface-container border border-line-hairline hover:border-line-focused cursor-pointer transition-colors"
                      >
                        <div className="flex items-center gap-2">
                          <div className="w-7 h-7 rounded-sm bg-primary-fixed text-on-primary-fixed flex items-center justify-center font-bold text-xs">
                            {w.name.charAt(0)}
                          </div>
                          <div>
                            <span className="font-bold text-xs text-on-surface block">{w.name}</span>
                            <span className="text-[11px] text-on-surface-variant block">
                              {w.trade} · {w.locationCluster} · Exp: {w.experienceYears} yrs
                            </span>
                          </div>
                        </div>
                        <div className="text-right">
                          <Badge tone="olive" size="sm">
                            ★ {w.rating.toFixed(2)}
                          </Badge>
                          <span className="text-[10px] font-mono text-outline block mt-0.5">
                            {w.jobsCompleted} jobs
                          </span>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* Societies */}
              {results.societies.length > 0 && (
                <div>
                  <div className="flex items-center justify-between text-[11px] font-bold uppercase tracking-wider text-outline mb-1.5 pb-1 border-b border-line-hairline">
                    <span>Primary Societies ({results.societies.length})</span>
                  </div>
                  <div className="space-y-1.5">
                    {results.societies.map((s) => (
                      <div
                        key={s.id}
                        onClick={() => handleSelect("/hierarchy")}
                        className="flex items-center justify-between p-2 rounded-sm bg-surface-container-low hover:bg-surface-container border border-line-hairline hover:border-line-focused cursor-pointer transition-colors"
                      >
                        <div>
                          <span className="font-bold text-xs text-on-surface block">{s.name}</span>
                          <span className="text-[11px] text-on-surface-variant block">
                            Secretary: {s.contactPerson} · {s.region}
                          </span>
                        </div>
                        <span className="font-mono text-[10px] text-primary-container font-semibold">
                          {s.code}
                        </span>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* Bulk Requests */}
              {results.bulkRequests.length > 0 && (
                <div>
                  <div className="flex items-center justify-between text-[11px] font-bold uppercase tracking-wider text-outline mb-1.5 pb-1 border-b border-line-hairline">
                    <span>Institutional Tenders ({results.bulkRequests.length})</span>
                  </div>
                  <div className="space-y-1.5">
                    {results.bulkRequests.map((b) => (
                      <div
                        key={b.id}
                        onClick={() => handleSelect("/bulk-requests")}
                        className="flex items-center justify-between p-2 rounded-sm bg-surface-container-low hover:bg-surface-container border border-line-hairline hover:border-line-focused cursor-pointer transition-colors"
                      >
                        <div>
                          <span className="font-bold text-xs text-on-surface block">{b.title}</span>
                          <span className="text-[11px] text-on-surface-variant block">
                            Client: {b.clientName} · Req: {b.requiredCount} {b.requiredTrade}
                          </span>
                        </div>
                        <Badge tone={b.status === "confirmed" ? "olive" : "terracotta"} size="sm">
                          {b.status.replace("_", " ")}
                        </Badge>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* SOS Alerts */}
              {results.sosAlerts.length > 0 && (
                <div>
                  <div className="flex items-center justify-between text-[11px] font-bold uppercase tracking-wider text-outline mb-1.5 pb-1 border-b border-line-hairline">
                    <span>Emergency SOS Alerts ({results.sosAlerts.length})</span>
                  </div>
                  <div className="space-y-1.5">
                    {results.sosAlerts.map((a) => (
                      <div
                        key={a.id}
                        onClick={() => handleSelect("/sos")}
                        className="flex items-center justify-between p-2 rounded-sm bg-surface-container-low hover:bg-surface-container border border-line-hairline hover:border-line-focused cursor-pointer transition-colors"
                      >
                        <div>
                          <span className="font-bold text-xs text-on-surface block">
                            #{a.id.toUpperCase()}: {a.workerName} ({a.trade})
                          </span>
                          <span className="text-[11px] text-on-surface-variant block truncate max-w-sm">
                            {a.location}
                          </span>
                        </div>
                        <Badge tone={a.status === "resolved" ? "olive" : a.status === "dispatched" ? "terracotta" : "rust"} size="sm">
                          {a.status}
                        </Badge>
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </>
          )}
        </div>
      </div>
    </Modal>
  );
};
