import React, { useState, useRef, useEffect } from "react";
import { useApp } from "../../context/AppContext";
import { Badge } from "../common/Badge";
import { Button } from "../common/Button";
import { useNavigate } from "react-router-dom";

interface TopbarProps {
  onOpenSearch: () => void;
  onToggleMobileMenu?: () => void;
}

export const Topbar: React.FC<TopbarProps> = ({
  onOpenSearch,
  onToggleMobileMenu,
}) => {
  const {
    currentAccount,
    currentNode,
    breadcrumbTrail,
    scopedSOSAlerts,
    notifications,
    markNotificationRead,
    markAllNotificationsRead,
    logout,
    isFederation,
    switchRole,
  } = useApp();

  const navigate = useNavigate();
  const [showNotifications, setShowNotifications] = useState(false);
  const [showProfileMenu, setShowProfileMenu] = useState(false);

  const notifRef = useRef<HTMLDivElement>(null);
  const profileRef = useRef<HTMLDivElement>(null);

  // Count active open SOS alerts
  const openSOSCount = scopedSOSAlerts.filter((a) => a.status === "open").length;
  const unreadNotifCount = notifications.filter((n) => !n.read).length;

  useEffect(() => {
    const handleClickOutside = (e: MouseEvent) => {
      if (notifRef.current && !notifRef.current.contains(e.target as Node)) {
        setShowNotifications(false);
      }
      if (profileRef.current && !profileRef.current.contains(e.target as Node)) {
        setShowProfileMenu(false);
      }
    };
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  const handleLogout = () => {
    logout();
    navigate("/login");
  };

  return (
    <header className="bg-white/90 backdrop-blur-md border-b border-stone-200/80 sticky top-0 z-40 w-full h-15 transition-all">
      <div className="flex justify-between items-center w-full px-4 lg:px-6 h-full gap-2">
        {/* Left Side: Mobile Menu, Brand Icon, and Hierarchy Breadcrumb */}
        <div className="flex items-center gap-3 overflow-hidden">
          {/* Mobile hamburger */}
          <button
            onClick={onToggleMobileMenu}
            className="lg:hidden w-8 h-8 flex items-center justify-center rounded-lg border border-stone-200 text-stone-700 hover:bg-stone-100"
          >
            <span className="material-symbols-outlined text-lg">menu</span>
          </button>

          {/* Federation Emblem */}
          <div
            onClick={() => navigate("/")}
            className="flex items-center gap-2.5 shrink-0 cursor-pointer"
          >
            <div className="w-8 h-8 rounded-xl bg-gradient-to-br from-[#B45309] to-[#803800] flex items-center justify-center text-white border border-amber-600/30 shadow-xs">
              <span className="material-symbols-outlined text-[18px]">
                {isFederation ? "account_balance" : "groups"}
              </span>
            </div>
            <div className="hidden sm:flex flex-col">
              <span className="font-headline font-bold text-sm tracking-tight text-stone-900 leading-none">
                SkillsKart
              </span>
              <span className="font-body text-[10px] text-amber-800 font-bold uppercase tracking-wider mt-0.5">
                {isFederation ? "Cooperative Federation" : "Cooperative Society"}
              </span>
            </div>
          </div>

          <div className="hidden md:block h-5 w-px bg-stone-200 mx-1" />

          {/* Tier-Coded Breadcrumb Trail */}
          <nav className="hidden md:flex items-center gap-1.5 text-xs text-stone-600 overflow-x-auto whitespace-nowrap scrollbar-none py-1">
            <Badge tone="olive" size="sm">
              {currentAccount?.badgeText || "CO-OP"}
            </Badge>

            {breadcrumbTrail.map((crumb, idx) => (
              <React.Fragment key={crumb.code || idx}>
                <span className="text-stone-300 text-[11px]">/</span>
                <span
                  className={`${
                    idx === breadcrumbTrail.length - 1
                      ? "font-bold text-stone-900"
                      : "text-stone-500 hover:text-stone-800"
                  } truncate max-w-[170px] text-xs`}
                  title={crumb.label}
                >
                  {crumb.label}
                </span>
              </React.Fragment>
            ))}
          </nav>
        </div>

        {/* Right Side: Role Toggle Pill, Global Search, SOS button, Notifications, Profile */}
        <div className="flex items-center gap-2 sm:gap-2.5 shrink-0">
          {/* Quick Role Switcher Pill */}
          <button
            type="button"
            onClick={() => switchRole(isFederation ? "society" : "federation")}
            className="hidden sm:flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-amber-50 hover:bg-amber-100/80 border border-amber-300/80 text-xs font-bold text-amber-900 shadow-2xs transition-all"
            title="Fast switch between Cooperative Federation and Cooperative Society"
          >
            <span className="material-symbols-outlined text-sm">sync_alt</span>
            <span className="text-[11px]">
              {isFederation ? "Switch to Society (Plumbers)" : "Switch to Federation"}
            </span>
          </button>

          {/* Global Search Bar Trigger */}
          <button
            onClick={onOpenSearch}
            className="flex items-center gap-2 bg-stone-50 hover:bg-stone-100 border border-stone-200/80 px-2.5 py-1.5 rounded-xl text-xs text-stone-500 transition-colors"
            title="Global search across workers and records (Ctrl + K)"
          >
            <span className="material-symbols-outlined text-base">search</span>
            <span className="hidden xl:inline text-[11px]">Search workers, trades, SOS...</span>
            <kbd className="hidden lg:inline text-[9px] bg-white px-1.5 py-0.5 rounded border border-stone-200 font-mono text-stone-500">
              ⌘K
            </kbd>
          </button>

          {/* Emergency SOS Pulse Button */}
          <button
            onClick={() => navigate("/sos")}
            className="bg-[#C2410C] text-white border border-[#9A3412] px-2.5 sm:px-3 py-1.5 rounded-xl text-[11px] font-bold font-body uppercase flex items-center gap-1.5 hover:bg-[#9A3412] active:scale-[0.98] shadow-xs transition-all"
            title="View Emergency SOS Queue"
          >
            <span className="material-symbols-outlined text-sm animate-pulse">
              e911_emergency
            </span>
            <span className="hidden sm:inline">SOS</span>
            <span className="bg-white text-[#991B1B] text-[10px] font-mono px-1.5 py-0.2 rounded-md font-bold">
              {openSOSCount}
            </span>
          </button>

          {/* Notification Center Dropdown */}
          <div className="relative" ref={notifRef}>
            <button
              onClick={() => setShowNotifications(!showNotifications)}
              className="relative w-9 h-9 flex items-center justify-center rounded-xl border border-stone-200 bg-white hover:bg-stone-50 text-stone-600 transition-colors"
              title="Notifications"
            >
              <span className="material-symbols-outlined text-base">notifications</span>
              {unreadNotifCount > 0 && (
                <span className="absolute top-1.5 right-1.5 w-2 h-2 rounded-full bg-[#C2410C] ring-2 ring-white" />
              )}
            </button>

            {showNotifications && (
              <div className="absolute right-0 mt-2 w-80 sm:w-96 bg-white border border-stone-200 rounded-2xl shadow-xl z-50 overflow-hidden animate-in fade-in zoom-in-95 duration-100">
                <div className="flex items-center justify-between p-3.5 border-b border-stone-100 bg-stone-50/70">
                  <div className="flex items-center gap-1.5">
                    <span className="font-bold text-xs text-stone-900 uppercase tracking-wider">
                      Ledger Notifications
                    </span>
                    {unreadNotifCount > 0 && (
                      <span className="bg-red-50 text-red-800 text-[10px] px-2 py-0.5 rounded-full font-bold border border-red-200">
                        {unreadNotifCount} new
                      </span>
                    )}
                  </div>
                  {unreadNotifCount > 0 && (
                    <button
                      onClick={markAllNotificationsRead}
                      className="text-[10px] text-amber-800 hover:underline font-bold"
                    >
                      Mark all read
                    </button>
                  )}
                </div>

                <div className="max-h-72 overflow-y-auto divide-y divide-stone-100">
                  {notifications.length === 0 ? (
                    <div className="p-4 text-center text-xs text-stone-400">
                      No notifications at this time
                    </div>
                  ) : (
                    notifications.map((n) => (
                      <div
                        key={n.id}
                        onClick={() => {
                          markNotificationRead(n.id);
                          if (n.linkTarget) {
                            navigate(n.linkTarget);
                            setShowNotifications(false);
                          }
                        }}
                        className={`p-3 text-xs cursor-pointer hover:bg-amber-50/40 transition-colors ${
                          !n.read ? "bg-amber-50/30" : ""
                        }`}
                      >
                        <div className="flex items-start justify-between gap-2">
                          <span
                            className={`font-bold text-[11px] ${
                              n.type === "sos"
                                ? "text-red-900"
                                : n.type === "bulk"
                                ? "text-amber-900"
                                : "text-stone-900"
                            }`}
                          >
                            {n.title}
                          </span>
                          <span className="text-[10px] text-stone-400 shrink-0">
                            {n.timestamp}
                          </span>
                        </div>
                        <p className="text-[11px] text-stone-600 mt-1 leading-snug">
                          {n.message}
                        </p>
                      </div>
                    ))
                  )}
                </div>
              </div>
            )}
          </div>

          {/* Admin Profile Dropdown */}
          <div className="relative" ref={profileRef}>
            <button
              onClick={() => setShowProfileMenu(!showProfileMenu)}
              className="flex items-center gap-2 pl-2 border-l border-stone-200 hover:opacity-90 transition-opacity"
              title="Admin account details"
            >
              <div className="w-8 h-8 rounded-xl bg-gradient-to-br from-amber-700 to-amber-900 text-white flex items-center justify-center font-bold text-xs border border-amber-600/30 shadow-2xs">
                {currentAccount?.officerName ? currentAccount.officerName.charAt(0) : "A"}
              </div>
              <div className="hidden lg:flex flex-col text-left">
                <span className="font-bold text-xs text-stone-900 leading-none truncate max-w-[120px]">
                  {currentAccount?.officerName || "Cooperative Admin"}
                </span>
                <span className="text-[10px] text-stone-500 truncate max-w-[120px] mt-0.5 font-medium">
                  {currentAccount?.designation || "Officer"}
                </span>
              </div>
              <span className="material-symbols-outlined text-stone-400 text-sm">
                expand_more
              </span>
            </button>

            {showProfileMenu && (
              <div className="absolute right-0 mt-2 w-72 bg-white border border-stone-200 rounded-2xl shadow-xl z-50 overflow-hidden animate-in fade-in zoom-in-95 duration-100 divide-y divide-stone-100 text-xs">
                <div className="p-4 bg-stone-50/70 space-y-1">
                  <span className="font-bold text-stone-900 block text-sm">
                    {currentAccount?.officerName}
                  </span>
                  <span className="text-xs text-stone-600 block">
                    {currentAccount?.designation}
                  </span>
                  <div className="pt-1 flex items-center gap-2">
                    <Badge tone="terracotta" size="sm">
                      {currentAccount?.tierLabel}
                    </Badge>
                  </div>
                  <div className="font-mono text-[10px] text-stone-500 pt-1 truncate">
                    Node: {currentNode?.code || "MH-FED-024"}
                  </div>
                </div>

                <div className="py-1">
                  <button
                    type="button"
                    onClick={() => {
                      switchRole(isFederation ? "society" : "federation");
                      setShowProfileMenu(false);
                    }}
                    className="w-full text-left px-3.5 py-2 text-stone-700 hover:bg-stone-50 flex items-center gap-2 font-semibold"
                  >
                    <span className="material-symbols-outlined text-base text-amber-800">
                      sync_alt
                    </span>
                    <span>
                      Switch to {isFederation ? "Society View" : "Federation View"}
                    </span>
                  </button>

                  <button
                    onClick={() => {
                      navigate("/profile");
                      setShowProfileMenu(false);
                    }}
                    className="w-full text-left px-3.5 py-2 text-stone-700 hover:bg-stone-50 flex items-center gap-2"
                  >
                    <span className="material-symbols-outlined text-base text-stone-400">
                      badge
                    </span>
                    <span>Admin Profile</span>
                  </button>

                  <button
                    onClick={() => {
                      navigate("/audit-log");
                      setShowProfileMenu(false);
                    }}
                    className="w-full text-left px-3.5 py-2 text-stone-700 hover:bg-stone-50 flex items-center gap-2"
                  >
                    <span className="material-symbols-outlined text-base text-stone-400">
                      history_edu
                    </span>
                    <span>Statutory Audit Log</span>
                  </button>
                </div>

                <div className="p-2.5 bg-stone-50">
                  <Button
                    variant="outlined"
                    size="sm"
                    className="w-full justify-center rounded-xl !text-[#C2410C] !border-[#C2410C]/40 hover:!bg-red-50 text-xs"
                    icon="logout"
                    onClick={handleLogout}
                  >
                    Switch Account / Log Out
                  </Button>
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </header>
  );
};
