import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useApp } from "../context/AppContext";
import { demoAccounts } from "../data/mockData";
import { Button } from "../components/common/Button";
import { Badge } from "../components/common/Badge";

export const LoginScreen: React.FC = () => {
  const { login } = useApp();
  const navigate = useNavigate();

  // 2 kinds of login: "federation" or "society"
  const [selectedRole, setSelectedRole] = useState<"federation" | "society">("federation");
  const [isSubmitting, setIsSubmitting] = useState(false);

  // Find corresponding dummy account
  const federationAccount =
    demoAccounts.find((a) => a.roleType === "federation") || demoAccounts[0];
  const societyAccount =
    demoAccounts.find((a) => a.roleType === "society") || demoAccounts[1];

  const activeAccount = selectedRole === "federation" ? federationAccount : societyAccount;

  const handleSignIn = (account = activeAccount) => {
    setIsSubmitting(true);
    setTimeout(() => {
      login(account.id);
      navigate("/");
    }, 250);
  };

  return (
    <div className="min-h-screen bg-[#FDFBF7] flex flex-col justify-between items-center px-4 py-6 sm:py-10 relative overflow-hidden font-body antialiased selection:bg-amber-100 selection:text-amber-900">
      {/* Warm Ambient Background Orbs */}
      <div className="absolute top-[-10%] left-1/2 -translate-x-1/2 w-[700px] h-[350px] bg-gradient-to-b from-amber-200/30 via-orange-100/20 to-transparent blur-3xl pointer-events-none rounded-full" />
      <div className="absolute bottom-[-10%] right-[-5%] w-[450px] h-[350px] bg-gradient-to-t from-orange-200/20 to-transparent blur-3xl pointer-events-none rounded-full" />

      {/* Top Bar / Header Branding */}
      <header className="w-full max-w-2xl flex items-center justify-between z-10">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-[#B45309] to-[#803800] text-white flex items-center justify-center shadow-md shadow-amber-950/15 border border-amber-600/30">
            <span className="material-symbols-outlined text-xl">account_balance</span>
          </div>
          <div>
            <div className="flex items-center gap-2">
              <span className="font-headline font-bold text-xl text-stone-900 tracking-tight leading-none">
                SkillsKart
              </span>
              <span className="text-[10px] uppercase font-bold tracking-wider px-2 py-0.5 rounded-full bg-amber-100 text-amber-900 border border-amber-300/60">
                Cooperative Platform
              </span>
            </div>
            <p className="text-[11px] text-stone-500 font-medium mt-0.5">
              India's Digital Marketplace for Labour Federations & Worker Societies
            </p>
          </div>
        </div>

        <div className="hidden sm:flex items-center gap-2 px-2.5 py-1 rounded-full bg-white/80 border border-stone-200/80 shadow-xs text-xs text-stone-600">
          <span className="w-2 h-2 rounded-full bg-emerald-600 animate-pulse" />
          <span className="font-medium text-[11px]">Sovereign Node v5.2</span>
        </div>
      </header>

      {/* Main Authentication Card */}
      <main className="w-full max-w-2xl my-auto z-10 py-4">
        <div className="bg-white border border-stone-200/90 rounded-2xl shadow-xl shadow-amber-950/5 p-6 sm:p-9 space-y-6">
          {/* Card Title & Introduction */}
          <div className="text-center space-y-1.5">
            <h1 className="font-headline text-2xl sm:text-3xl font-bold text-stone-900 tracking-tight">
              Select Your Cooperative Login
            </h1>
            <p className="text-xs sm:text-sm text-stone-600 max-w-lg mx-auto leading-relaxed">
              Choose your administrative role to access real-time governance, service tariffs, and worker registries.
            </p>
          </div>

          {/* 2 Kinds of Login: Cooperative Federation vs Cooperative Society */}
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3.5 pt-2">
            {/* OPTION 1: Cooperative Federation */}
            <button
              type="button"
              onClick={() => setSelectedRole("federation")}
              className={`p-4 rounded-xl border text-left transition-all duration-200 relative ${
                selectedRole === "federation"
                  ? "border-[#B45309] bg-gradient-to-br from-amber-50/70 to-orange-50/30 ring-2 ring-[#B45309]/30 shadow-md shadow-amber-900/5"
                  : "border-stone-200 bg-stone-50/40 hover:bg-stone-50 hover:border-stone-300"
              }`}
            >
              <div className="flex items-center justify-between mb-3">
                <div
                  className={`w-9 h-9 rounded-lg flex items-center justify-center ${
                    selectedRole === "federation"
                      ? "bg-[#B45309] text-white shadow-sm"
                      : "bg-stone-200/70 text-stone-600"
                  }`}
                >
                  <span className="material-symbols-outlined text-xl">account_balance</span>
                </div>
                <span
                  className={`material-symbols-outlined text-xl ${
                    selectedRole === "federation" ? "text-[#B45309]" : "text-stone-300"
                  }`}
                >
                  {selectedRole === "federation" ? "check_circle" : "radio_button_unchecked"}
                </span>
              </div>

              <div className="space-y-0.5">
                <h2 className="font-headline font-bold text-base text-stone-900">
                  Cooperative Federation
                </h2>
                <p className="text-[11px] font-medium text-amber-800">
                  State & Regional Apex Governance
                </p>
              </div>
            </button>

            {/* OPTION 2: Cooperative Society */}
            <button
              type="button"
              onClick={() => setSelectedRole("society")}
              className={`p-4 rounded-xl border text-left transition-all duration-200 relative ${
                selectedRole === "society"
                  ? "border-[#B45309] bg-gradient-to-br from-amber-50/70 to-orange-50/30 ring-2 ring-[#B45309]/30 shadow-md shadow-amber-900/5"
                  : "border-stone-200 bg-stone-50/40 hover:bg-stone-50 hover:border-stone-300"
              }`}
            >
              <div className="flex items-center justify-between mb-3">
                <div
                  className={`w-9 h-9 rounded-lg flex items-center justify-center ${
                    selectedRole === "society"
                      ? "bg-[#B45309] text-white shadow-sm"
                      : "bg-stone-200/70 text-stone-600"
                  }`}
                >
                  <span className="material-symbols-outlined text-xl">groups</span>
                </div>
                <span
                  className={`material-symbols-outlined text-xl ${
                    selectedRole === "society" ? "text-[#B45309]" : "text-stone-300"
                  }`}
                >
                  {selectedRole === "society" ? "check_circle" : "radio_button_unchecked"}
                </span>
              </div>

              <div className="space-y-0.5">
                <h2 className="font-headline font-bold text-base text-stone-900">
                  Cooperative Society
                </h2>
                <p className="text-[11px] font-medium text-amber-800">
                  Primary Worker Collective & Guild
                </p>
              </div>
            </button>
          </div>

          {/* DUMMY ACCOUNT DETAILS PREVIEW CARD */}
          <div className="p-4 rounded-xl bg-stone-50 border border-stone-200/80 space-y-3">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <span className="text-[10px] uppercase font-bold tracking-wider text-amber-900 bg-amber-100/80 px-2 py-0.5 rounded-full border border-amber-300/60">
                  Ready Dummy Account
                </span>
                <span className="text-xs text-stone-400">·</span>
                <span className="text-xs text-stone-500 font-medium">Instant 1-Click Access</span>
              </div>
              <span className="inline-flex items-center gap-1 text-[11px] text-emerald-700 font-bold">
                <span className="w-1.5 h-1.5 rounded-full bg-emerald-600" />
                Verified Active
              </span>
            </div>

            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 pt-1">
              <div className="flex items-center gap-3">
                <div className="w-11 h-11 rounded-full bg-gradient-to-br from-amber-700 to-amber-900 text-white font-bold flex items-center justify-center text-sm shadow-xs border-2 border-white">
                  {activeAccount.officerName.charAt(0)}
                </div>
                <div>
                  <div className="flex items-center gap-2">
                    <span className="font-bold text-sm text-stone-900">
                      {activeAccount.officerName}
                    </span>
                    <Badge tone="terracotta" size="sm">
                      {activeAccount.badgeText}
                    </Badge>
                  </div>
                  <p className="text-xs text-stone-600 line-clamp-1">
                    {activeAccount.designation} · <strong className="text-stone-800">{activeAccount.name}</strong>
                  </p>
                  <p className="text-[11px] text-stone-500 mt-0.5 font-mono">
                    Node Code: {activeAccount.code} · Scope: {activeAccount.jurisdictionScope}
                  </p>
                </div>
              </div>
            </div>

            {/* Key Capabilities Bullet Points */}
            <div className="pt-2 border-t border-stone-200/60 grid grid-cols-1 sm:grid-cols-2 gap-2 text-xs text-stone-600">
              {selectedRole === "federation" ? (
                <>
                  <div className="flex items-center gap-1.5">
                    <span className="material-symbols-outlined text-amber-700 text-sm">hub</span>
                    <span>View all enrolled primary societies & audits</span>
                  </div>
                  <div className="flex items-center gap-1.5">
                    <span className="material-symbols-outlined text-amber-700 text-sm">analytics</span>
                    <span>Area Demand & Availability (Plumbers, Electricians...)</span>
                  </div>
                  <div className="flex items-center gap-1.5">
                    <span className="material-symbols-outlined text-amber-700 text-sm">price_change</span>
                    <span>Set statutory Base Price Floor & Ceiling caps</span>
                  </div>
                  <div className="flex items-center gap-1.5">
                    <span className="material-symbols-outlined text-amber-700 text-sm">balance</span>
                    <span>Rebalance technician dispatches to deficit zones</span>
                  </div>
                </>
              ) : (
                <>
                  <div className="flex items-center gap-1.5">
                    <span className="material-symbols-outlined text-amber-700 text-sm">badge</span>
                    <span>Member workers roster dashboard on home page</span>
                  </div>
                  <div className="flex items-center gap-1.5">
                    <span className="material-symbols-outlined text-amber-700 text-sm">sell</span>
                    <span>Set particular task prices (Tap, Shower, etc.)</span>
                  </div>
                  <div className="flex items-center gap-1.5">
                    <span className="material-symbols-outlined text-amber-700 text-sm">verified_user</span>
                    <span>e-Shram, BOCW & Group Health Insurance tracking</span>
                  </div>
                  <div className="flex items-center gap-1.5">
                    <span className="material-symbols-outlined text-amber-700 text-sm">person_add</span>
                    <span>Direct frictionless member enrolment</span>
                  </div>
                </>
              )}
            </div>
          </div>

          {/* Quick Sign In Button */}
          <div className="pt-1">
            <Button
              variant="primary"
              size="lg"
              className="w-full justify-center text-sm font-bold tracking-wide py-3.5 rounded-xl shadow-md shadow-amber-900/15"
              onClick={() => handleSignIn()}
              disabled={isSubmitting}
            >
              {isSubmitting ? "Signing In..." : "Sign In"}
            </Button>
          </div>
        </div>
      </main>
    </div>
  );
};
