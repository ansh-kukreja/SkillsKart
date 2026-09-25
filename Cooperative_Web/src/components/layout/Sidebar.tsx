import React from "react";
import { NavLink, useNavigate } from "react-router-dom";
import { useApp } from "../../context/AppContext";
import { Badge } from "../common/Badge";
import { Button } from "../common/Button";

interface SidebarProps {
  isOpen?: boolean;
  onClose?: () => void;
}

export const Sidebar: React.FC<SidebarProps> = ({ isOpen = true, onClose }) => {
  const { currentAccount, currentNode, scopedSOSAlerts, scopedBulkRequests, logout, isFederation, switchRole } = useApp();
  const navigate = useNavigate();

  const openSOSCount = scopedSOSAlerts.filter((a) => a.status === "open").length;
  const pendingBulkCount = scopedBulkRequests.filter((b) => b.status === "pending_review").length;

  const handleLogout = () => {
    logout();
    navigate("/login");
  };

  const navItemClass = ({ isActive }: { isActive: boolean }) =>
    `flex items-center justify-between px-3.5 py-2.5 rounded-xl text-xs font-bold transition-all duration-150 select-none ${
      isActive
        ? "bg-gradient-to-r from-[#B45309] to-[#92400E] text-white shadow-xs"
        : "text-stone-600 hover:text-stone-900 hover:bg-stone-100/80"
    }`;

  const navIconClass = (isActive: boolean) =>
    `material-symbols-outlined text-[19px] mr-3 ${
      isActive ? "text-white" : "text-stone-400 group-hover:text-stone-600"
    }`;

  const sidebarContent = (
    <div className="flex flex-col justify-between h-full p-4 overflow-y-auto font-body">
      <div className="space-y-6">
        {/* Node Identification Card */}
        <div className="p-3.5 border border-stone-200/80 bg-stone-50/80 rounded-2xl space-y-2">
          <div className="flex items-center justify-between">
            <span className="font-bold text-[10px] uppercase tracking-wider text-amber-900 bg-amber-100/80 px-2 py-0.5 rounded-full">
              {isFederation ? "Apex Federation" : "Primary Society"}
            </span>
            <span className="flex items-center gap-1 text-[11px] font-bold text-emerald-700">
              <span className="w-1.5 h-1.5 rounded-full bg-emerald-600 animate-pulse" />
              Live
            </span>
          </div>

          <h2 className="font-headline font-bold text-xs text-stone-900 line-clamp-2 leading-snug">
            {currentNode?.name || "SkillsKart Governance Node"}
          </h2>

          <div className="flex items-center justify-between pt-2 border-t border-stone-200/70 text-[10px] text-stone-500 font-mono">
            <span>{currentNode?.code || "MH-FED-024"}</span>
            <span className="uppercase font-bold text-amber-900">
              {currentAccount?.officerName ? currentAccount.officerName.split(" ")[0] : "Admin"}
            </span>
          </div>
        </div>

        {/* Navigation Groups */}
        {/* Group 1: Core Operations */}
        <div className="space-y-1">
          <span className="block px-3 text-[10px] font-bold uppercase tracking-wider text-stone-400 pb-1">
            Core Ledger
          </span>

          <NavLink to="/" end className={navItemClass}>
            {({ isActive }) => (
              <div className="flex items-center w-full justify-between">
                <div className="flex items-center">
                  <span className={navIconClass(isActive)}>dashboard</span>
                  <span>Dashboard</span>
                </div>
              </div>
            )}
          </NavLink>

          <NavLink to="/hierarchy" className={navItemClass}>
            {({ isActive }) => (
              <div className="flex items-center">
                <span className={navIconClass(isActive)}>account_tree</span>
                <span>Hierarchy Node</span>
              </div>
            )}
          </NavLink>

          <NavLink to="/directory" className={navItemClass}>
            {({ isActive }) => (
              <div className="flex items-center">
                <span className={navIconClass(isActive)}>engineering</span>
                <span>Worker Registry</span>
              </div>
            )}
          </NavLink>

          <NavLink to="/sos" className={navItemClass}>
            {({ isActive }) => (
              <div className="flex items-center w-full justify-between">
                <div className="flex items-center">
                  <span className={navIconClass(isActive)}>e911_emergency</span>
                  <span>Emergency SOS</span>
                </div>
                {openSOSCount > 0 && (
                  <span
                    className={`text-[10px] font-mono px-2 py-0.5 rounded-full font-bold ${
                      isActive
                        ? "bg-white text-red-900"
                        : "bg-red-100 text-red-900 border border-red-200"
                    }`}
                  >
                    {openSOSCount}
                  </span>
                )}
              </div>
            )}
          </NavLink>
        </div>

        {/* Group 2: Services & Market */}
        <div className="space-y-1">
          <span className="block px-3 text-[10px] font-bold uppercase tracking-wider text-stone-400 pb-1">
            Tariffs & Operations
          </span>

          <NavLink to="/rate-cards" className={navItemClass}>
            {({ isActive }) => (
              <div className="flex items-center">
                <span className={navIconClass(isActive)}>price_change</span>
                <span>Trade Rate Cards</span>
              </div>
            )}
          </NavLink>

          <NavLink to="/forecast" className={navItemClass}>
            {({ isActive }) => (
              <div className="flex items-center">
                <span className={navIconClass(isActive)}>monitoring</span>
                <span>Demand Forecast</span>
              </div>
            )}
          </NavLink>

          <NavLink to="/bulk-requests" className={navItemClass}>
            {({ isActive }) => (
              <div className="flex items-center w-full justify-between">
                <div className="flex items-center">
                  <span className={navIconClass(isActive)}>assignment</span>
                  <span>Bulk Tenders</span>
                </div>
                {pendingBulkCount > 0 && (
                  <span
                    className={`text-[10px] font-mono px-2 py-0.5 rounded-full font-bold ${
                      isActive
                        ? "bg-white text-amber-900"
                        : "bg-amber-100 text-amber-900 border border-amber-200"
                    }`}
                  >
                    {pendingBulkCount}
                  </span>
                )}
              </div>
            )}
          </NavLink>
        </div>

        {/* Group 3: Governance & Records */}
        <div className="space-y-1">
          <span className="block px-3 text-[10px] font-bold uppercase tracking-wider text-stone-400 pb-1">
            Governance & Audit
          </span>

          <NavLink to="/audit-log" className={navItemClass}>
            {({ isActive }) => (
              <div className="flex items-center">
                <span className={navIconClass(isActive)}>history_edu</span>
                <span>Audit Ledger</span>
              </div>
            )}
          </NavLink>

          <NavLink to="/profile" className={navItemClass}>
            {({ isActive }) => (
              <div className="flex items-center">
                <span className={navIconClass(isActive)}>settings</span>
                <span>Admin Profile</span>
              </div>
            )}
          </NavLink>
        </div>
      </div>

      {/* Bottom Footer & Switch Role / Logout */}
      <div className="pt-4 border-t border-stone-200/80 space-y-2.5">
        <button
          type="button"
          onClick={() => switchRole(isFederation ? "society" : "federation")}
          className="w-full flex items-center justify-center gap-1.5 px-3 py-2 rounded-xl bg-amber-50 hover:bg-amber-100 text-amber-900 border border-amber-300 text-xs font-bold transition-colors"
        >
          <span className="material-symbols-outlined text-sm">sync_alt</span>
          <span>Switch to {isFederation ? "Society" : "Federation"}</span>
        </button>

        <Button
          variant="outlined"
          size="sm"
          className="w-full justify-center rounded-xl !text-[#C2410C] !border-[#C2410C]/30 hover:!bg-red-50 text-xs font-bold"
          icon="logout"
          onClick={handleLogout}
        >
          Exit Session
        </Button>
      </div>
    </div>
  );

  return (
    <>
      {/* Desktop Sidebar (persistent) */}
      <aside className="hidden lg:block w-64 bg-white border-r border-stone-200/80 h-[calc(100vh-3.75rem)] sticky top-15 shrink-0">
        {sidebarContent}
      </aside>

      {/* Mobile Drawer */}
      {isOpen && (
        <div className="lg:hidden fixed inset-0 z-50 flex">
          <div
            className="fixed inset-0 bg-black/50 backdrop-blur-sm"
            onClick={onClose}
          />
          <div className="relative w-64 max-w-[80vw] bg-white border-r border-stone-200 h-full z-10 shadow-2xl">
            {sidebarContent}
          </div>
        </div>
      )}
    </>
  );
};
