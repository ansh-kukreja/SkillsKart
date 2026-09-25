import React, { useState } from "react";
import { useApp } from "../context/AppContext";
import { Button } from "../components/common/Button";
import { Badge } from "../components/common/Badge";
import { useNavigate } from "react-router-dom";

export const AdminProfileScreen: React.FC = () => {
  const { currentAccount, currentNode, breadcrumbTrail, logout } = useApp();
  const navigate = useNavigate();

  const [soundAlarms, setSoundAlarms] = useState(true);
  const [compactTables, setCompactTables] = useState(false);
  const [autoSyncLedger, setAutoSyncLedger] = useState(true);
  const [savedFeedback, setSavedFeedback] = useState(false);

  const handleSavePreferences = () => {
    setSavedFeedback(true);
    setTimeout(() => setSavedFeedback(false), 2000);
  };

  const handleLogout = () => {
    logout();
    navigate("/login");
  };

  return (
    <div className="space-y-6 max-w-4xl mx-auto">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-line-hairline">
        <div>
          <div className="flex items-center gap-2 mb-1">
            <span className="text-[10px] uppercase font-bold tracking-widest text-[#B45309]">
              Administrative Credentials
            </span>
            <span className="text-outline">·</span>
            <Badge tone="olive" size="sm">
              Session Active
            </Badge>
          </div>
          <h1 className="font-headline text-2xl sm:text-3xl font-semibold text-on-surface tracking-tight">
            Admin Profile & Governance Settings
          </h1>
          <p className="font-body text-xs text-on-surface-variant mt-0.5">
            Operational credentials and terminal preferences for the current logged-in federation administrator.
          </p>
        </div>

        <Button
          variant="secondary"
          size="md"
          icon="logout"
          onClick={handleLogout}
        >
          Switch Demo Account
        </Button>
      </div>

      {/* Account Details Card */}
      <div className="bg-surface-container-lowest border border-line-hairline p-5 rounded-DEFAULT ledger-offset-shadow space-y-4">
        <div className="flex items-start justify-between border-b border-line-hairline pb-4">
          <div className="flex items-center gap-3.5">
            <div className="w-14 h-14 rounded-DEFAULT bg-primary-container text-white flex items-center justify-center font-headline text-2xl font-bold border border-[#92400E] shadow-sm">
              {currentAccount?.officerName ? currentAccount.officerName.charAt(0) : "A"}
            </div>
            <div>
              <div className="flex items-center gap-2">
                <h2 className="font-headline text-lg font-semibold text-on-surface">
                  {currentAccount?.officerName}
                </h2>
                <Badge tone="olive" size="sm">
                  {currentAccount?.tierLabel}
                </Badge>
              </div>
              <span className="text-xs text-[#B45309] font-bold block">
                {currentAccount?.designation}
              </span>
              <span className="text-[11px] text-outline font-mono mt-0.5 block">
                Node ID: {currentNode?.code || currentAccount?.code}
              </span>
            </div>
          </div>

          <div className="text-right text-xs">
            <span className="text-[10px] uppercase font-bold text-outline block">
              Hierarchy Tier:
            </span>
            <span className="font-headline text-base font-bold text-primary-container uppercase">
              {currentAccount?.tier}
            </span>
          </div>
        </div>

        {/* Federation Jurisdiction Chain */}
        <div className="space-y-1.5 pt-1">
          <span className="text-[10px] uppercase font-bold tracking-wider text-outline block">
            Parent Federation Jurisdiction Chain:
          </span>
          <div className="bg-surface-container-low p-3 rounded-sm border border-line-hairline flex flex-wrap items-center gap-2 text-xs">
            {breadcrumbTrail.map((item, i) => (
              <React.Fragment key={i}>
                <span className="font-semibold text-on-surface bg-white px-2 py-0.5 rounded border border-line-hairline">
                  {item.label} ({item.tier})
                </span>
                {i < breadcrumbTrail.length - 1 && (
                  <span className="text-primary font-bold">→</span>
                )}
              </React.Fragment>
            ))}
          </div>
        </div>

        {/* Contact Coordinates */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-2 text-xs">
          <div className="bg-surface-container-low p-3 rounded-sm border border-line-hairline">
            <span className="text-[10px] uppercase font-bold text-outline block mb-1">
              Registered Telephone & Dispatch Desk
            </span>
            <span className="font-mono font-bold text-on-surface block text-sm">
              {currentNode?.contactPhone || "+91 20 2612 8844"}
            </span>
            <span className="text-[11px] text-outline mt-0.5 block">
              Direct line to zonal cooperative directorate
            </span>
          </div>

          <div className="bg-surface-container-low p-3 rounded-sm border border-line-hairline">
            <span className="text-[10px] uppercase font-bold text-outline block mb-1">
              Official Cooperative Email
            </span>
            <span className="font-mono font-bold text-on-surface block text-sm truncate">
              {currentNode?.contactEmail || "registrar@gigfederation.gov.in"}
            </span>
            <span className="text-[11px] text-outline mt-0.5 block">
              Govt Multi-State Cooperative Gateway
            </span>
          </div>
        </div>
      </div>

      {/* Terminal Display & Operational Preferences */}
      <div className="bg-surface-container-lowest border border-line-hairline p-5 rounded-DEFAULT ledger-offset-shadow space-y-4">
        <div className="flex items-center justify-between border-b border-line-hairline pb-3">
          <div>
            <h3 className="font-headline text-base font-semibold text-on-surface">
              Terminal Preferences
            </h3>
            <p className="font-body text-xs text-on-surface-variant">
              Configure alert behaviors, density scaling, and local ledger synchronization.
            </p>
          </div>
          {savedFeedback && (
            <span className="text-xs text-tertiary font-bold flex items-center gap-1 animate-in fade-in">
              <span className="material-symbols-outlined text-sm">check</span>
              Preferences Saved
            </span>
          )}
        </div>

        <div className="space-y-3 divide-y divide-line-hairline text-xs">
          {/* Preference 1 */}
          <div className="flex items-center justify-between pt-2">
            <div>
              <span className="font-bold text-on-surface block">
                Emergency SOS Audio Sirens
              </span>
              <span className="text-outline text-[11px]">
                Play high-urgency tone whenever an unassigned SOS incident enters the queue.
              </span>
            </div>
            <input
              type="checkbox"
              checked={soundAlarms}
              onChange={(e) => setSoundAlarms(e.target.checked)}
              className="rounded text-primary-container focus:ring-primary-container w-4 h-4 cursor-pointer"
            />
          </div>

          {/* Preference 2 */}
          <div className="flex items-center justify-between pt-3">
            <div>
              <span className="font-bold text-on-surface block">
                High-Density Ledger Mode
              </span>
              <span className="text-outline text-[11px]">
                Compress padding across tables and rows for rapid archival auditing.
              </span>
            </div>
            <input
              type="checkbox"
              checked={compactTables}
              onChange={(e) => setCompactTables(e.target.checked)}
              className="rounded text-primary-container focus:ring-primary-container w-4 h-4 cursor-pointer"
            />
          </div>

          {/* Preference 3 */}
          <div className="flex items-center justify-between pt-3">
            <div>
              <span className="font-bold text-on-surface block">
                Automated State Gazette Sync
              </span>
              <span className="text-outline text-[11px]">
                Sync local hierarchy additions and rate revisions to state ledger hourly.
              </span>
            </div>
            <input
              type="checkbox"
              checked={autoSyncLedger}
              onChange={(e) => setAutoSyncLedger(e.target.checked)}
              className="rounded text-primary-container focus:ring-primary-container w-4 h-4 cursor-pointer"
            />
          </div>
        </div>

        <div className="flex justify-end pt-3 border-t border-line-hairline">
          <Button
            variant="primary"
            size="md"
            icon="save"
            onClick={handleSavePreferences}
          >
            Save Preferences
          </Button>
        </div>
      </div>
    </div>
  );
};
