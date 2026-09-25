import React from "react";
import { useApp } from "../context/AppContext";
import { Button } from "../components/common/Button";
import { Badge } from "../components/common/Badge";
import {
  ResponsiveContainer,
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  AreaChart,
  Area,
} from "recharts";

export const DemandForecastScreen: React.FC = () => {
  const { isForecastReadinessPassed, toggleDemandReadiness, currentNode } = useApp();

  // Forecast projection dataset for next 6 months
  const monthlyForecast = [
    { month: "Oct 26", projectedDemand: 4200, currentCapacity: 3800, variance: -400 },
    { month: "Nov 26", projectedDemand: 5100, currentCapacity: 3950, variance: -1150 }, // Festival surge
    { month: "Dec 26", projectedDemand: 4600, currentCapacity: 4100, variance: -500 },
    { month: "Jan 27", projectedDemand: 3900, currentCapacity: 4200, variance: 300 },
    { month: "Feb 27", projectedDemand: 4100, currentCapacity: 4300, variance: 200 },
    { month: "Mar 27", projectedDemand: 5300, currentCapacity: 4400, variance: -900 }, // Pre-summer AC surge
  ];

  // Demand breakdown by blue-collar trade
  const tradeForecast = [
    { trade: "Electrical", currentActive: 120, projectedNeeded: 165, surge: "+37%" },
    { trade: "Plumbing", currentActive: 95, projectedNeeded: 110, surge: "+15%" },
    { trade: "Appliance & AC", currentActive: 85, projectedNeeded: 140, surge: "+64%" },
    { trade: "Painting", currentActive: 70, projectedNeeded: 105, surge: "+50%" },
    { trade: "Carpentry", currentActive: 65, projectedNeeded: 75, surge: "+15%" },
    { trade: "Deep Cleaning", currentActive: 110, projectedNeeded: 150, surge: "+36%" },
  ];

  const readinessCriteria = [
    {
      title: "Minimum Historical Completed Jobs",
      required: "500+ verified service completions in jurisdiction",
      current: isForecastReadinessPassed ? "1,240 completed jobs" : "210 completed jobs",
      passed: isForecastReadinessPassed,
    },
    {
      title: "Technician Density by Trade",
      required: "Min. 10 active blue-collar workers per trade cluster",
      current: isForecastReadinessPassed ? "14 active per trade" : "6 active per trade (Deficit)",
      passed: isForecastReadinessPassed,
    },
    {
      title: "Seasonal Festival & Weather Coefficients",
      required: "Pre-Diwali painting & pre-summer AC maintenance telemetry",
      current: isForecastReadinessPassed ? "Telemetry calibrated (v2.4)" : "Missing weather sensor telemetry",
      passed: isForecastReadinessPassed,
    },
    {
      title: "Institutional Municipal Work Order History",
      required: "At least 3 completed bulk tenders on ledger",
      current: isForecastReadinessPassed ? "5 confirmed tenders" : "1 confirmed tender (Below threshold)",
      passed: isForecastReadinessPassed,
    },
  ];

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-line-hairline">
        <div>
          <div className="flex items-center gap-2 mb-1">
            <span className="text-[10px] uppercase font-bold tracking-widest text-[#B45309]">
              Predictive Planning
            </span>
            <span className="text-outline">·</span>
            <Badge tone={isForecastReadinessPassed ? "olive" : "terracotta"} size="sm">
              {isForecastReadinessPassed ? "Readiness Check Passed" : "Readiness Check Pending"}
            </Badge>
          </div>
          <h1 className="font-headline text-2xl sm:text-3xl font-semibold text-on-surface tracking-tight">
            Cooperative Demand Forecast & Readiness Engine
          </h1>
          <p className="font-body text-xs text-on-surface-variant mt-0.5">
            Jurisdiction: <strong className="text-on-surface">{currentNode?.name}</strong>. Strictly gated by statistical readiness checks to prevent inaccurate capacity projections.
          </p>
        </div>

        {/* Demo Toggle Control */}
        <div className="flex items-center gap-3 bg-surface-container-low border border-line-focused p-2 rounded-DEFAULT shrink-0">
          <div className="text-right text-xs">
            <span className="font-bold text-on-surface block text-[11px]">
              Demo Gate Simulation:
            </span>
            <span className="text-[10px] text-outline">
              {isForecastReadinessPassed ? "Threshold Met (94%)" : "Threshold Deficit (48%)"}
            </span>
          </div>
          <Button
            variant={isForecastReadinessPassed ? "primary" : "secondary"}
            size="sm"
            icon={isForecastReadinessPassed ? "toggle_on" : "toggle_off"}
            onClick={() => toggleDemandReadiness()}
          >
            {isForecastReadinessPassed ? "Simulate Gate Failure" : "Simulate Gate Pass"}
          </Button>
        </div>
      </div>

      {/* READINESS CHECK STATUS BOX */}
      <div
        className={`p-4 rounded-DEFAULT border ${
          isForecastReadinessPassed
            ? "bg-[#F2F7EC] border-[#84CC16]"
            : "bg-[#FFFDF7] border-[#F59E0B]"
        } space-y-3 shadow-sm`}
      >
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <span
              className={`material-symbols-outlined text-xl ${
                isForecastReadinessPassed ? "text-[#365314]" : "text-[#92400E]"
              }`}
            >
              {isForecastReadinessPassed ? "verified" : "warning"}
            </span>
            <span
              className={`font-headline text-sm font-bold uppercase tracking-wider ${
                isForecastReadinessPassed ? "text-[#365314]" : "text-[#92400E]"
              }`}
            >
              Prerequisite Data Readiness Audit:{" "}
              {isForecastReadinessPassed ? "PASSED (4 of 4 Criteria)" : "INSUFFICIENT (1 of 4 Criteria)"}
            </span>
          </div>

          <Badge tone={isForecastReadinessPassed ? "olive" : "terracotta"} size="sm">
            {isForecastReadinessPassed ? "94% Statistical Confidence" : "Gated / Locked"}
          </Badge>
        </div>

        {/* Criteria Checklist */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3 pt-1">
          {readinessCriteria.map((item, idx) => (
            <div
              key={idx}
              className="bg-white p-2.5 rounded-sm border border-line-hairline text-xs space-y-1"
            >
              <div className="flex items-center justify-between">
                <span className="font-bold text-on-surface line-clamp-1">{item.title}</span>
                <span
                  className={`material-symbols-outlined text-base ${
                    item.passed ? "text-tertiary" : "text-[#C2410C]"
                  }`}
                >
                  {item.passed ? "check_circle" : "cancel"}
                </span>
              </div>
              <span className="text-[10px] text-outline block line-clamp-1">{item.required}</span>
              <span
                className={`font-mono text-[11px] font-semibold block ${
                  item.passed ? "text-tertiary" : "text-[#C2410C]"
                }`}
              >
                {item.current}
              </span>
            </div>
          ))}
        </div>
      </div>

      {/* CONDITIONAL RENDERING: LOCKED STATE (Never show numbers) vs UNLOCKED FORECAST */}
      {!isForecastReadinessPassed ? (
        /* Gated / Locked State: Clear "Not Enough Data Yet" */
        <div className="bg-surface-container-lowest border-2 border-dashed border-[#D6C7B2] rounded-DEFAULT p-8 sm:p-12 text-center space-y-4">
          <div className="w-16 h-16 rounded-DEFAULT bg-[#FEF3C7] border border-[#F59E0B] text-[#92400E] mx-auto flex items-center justify-center">
            <span className="material-symbols-outlined text-4xl">lock_clock</span>
          </div>

          <div className="max-w-md mx-auto space-y-2">
            <h3 className="font-headline text-xl font-semibold text-on-surface">
              Not Enough Historical Data for Predictive Forecasting
            </h3>
            <p className="font-body text-xs text-on-surface-variant leading-relaxed">
              In accordance with cooperative governance protocols, predictive workforce algorithms remain strictly disabled until local jurisdiction meets the minimum data confidence threshold. No projection numbers can be generated at this time.
            </p>
          </div>

          {/* Missing Parameters Summary */}
          <div className="max-w-lg mx-auto bg-surface-container-low border border-line-hairline p-4 rounded-sm text-left text-xs space-y-2">
            <span className="font-bold text-[11px] uppercase tracking-wider text-[#92400E] block">
              Parameters Currently Missing or Below Threshold:
            </span>
            <ul className="list-disc list-inside space-y-1 text-on-surface-variant text-[11px]">
              <li>
                <strong>Completed Bookings:</strong> Need 290 more service executions logged in this society cluster.
              </li>
              <li>
                <strong>Technician Density:</strong> Need at least 4 more enrolled electricians and 3 more HVAC technicians.
              </li>
              <li>
                <strong>Seasonal Telemetry:</strong> Regional weather and festival index not yet synchronized for Q4.
              </li>
            </ul>
          </div>

          <div className="pt-2">
            <Button
              variant="primary"
              size="md"
              icon="toggle_on"
              onClick={() => toggleDemandReadiness(true)}
            >
              Simulate Gate Pass (Unlock Demo Visuals)
            </Button>
          </div>
        </div>
      ) : (
        /* Unlocked State: High-Confidence Forecast Visuals */
        <div className="space-y-6">
          {/* Top Surge Alert Banner */}
          <div className="bg-[#FFFDF7] border border-[#F59E0B] p-4 rounded-DEFAULT ledger-offset-shadow flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 text-xs">
            <div className="flex items-center gap-3">
              <div className="w-9 h-9 rounded-sm bg-[#B45309] text-white flex items-center justify-center font-bold">
                <span className="material-symbols-outlined text-lg">trending_up</span>
              </div>
              <div>
                <span className="font-bold text-on-surface block text-sm">
                  Upcoming Demand Surge: Pre-Diwali & Seasonal HVAC Overhaul
                </span>
                <span className="text-on-surface-variant text-xs">
                  Predicted 38% peak spike in October–November across Painting, Electrical, and Appliance Deep Cleaning trades.
                </span>
              </div>
            </div>
            <div className="font-mono text-right shrink-0">
              <span className="font-bold text-tertiary block text-sm">94.2% Confidence</span>
              <span className="text-[10px] text-outline">Bayesian Time-Series Model</span>
            </div>
          </div>

          {/* Charts Row */}
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-5">
            {/* Chart 1: Projected Demand vs Current Active Capacity */}
            <div className="lg:col-span-7 bg-surface-container-lowest border border-line-hairline p-5 rounded-DEFAULT ledger-offset-shadow space-y-4">
              <div className="flex items-center justify-between border-b border-line-hairline pb-3">
                <div>
                  <span className="text-[10px] uppercase font-bold tracking-wider text-outline block">
                    6-Month Horizon
                  </span>
                  <h3 className="font-headline text-base font-semibold text-on-surface">
                    Projected Service Demand vs. Active Workforce Capacity
                  </h3>
                </div>
                <Badge tone="olive" size="sm">
                  Active Model
                </Badge>
              </div>

              <div className="h-64 sm:h-72 w-full pt-1">
                <ResponsiveContainer width="100%" height="100%">
                  <AreaChart data={monthlyForecast} margin={{ top: 10, right: 10, left: -15, bottom: 0 }}>
                    <defs>
                      <linearGradient id="demandGrad" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="5%" stopColor="#C2410C" stopOpacity={0.25} />
                        <stop offset="95%" stopColor="#C2410C" stopOpacity={0.0} />
                      </linearGradient>
                      <linearGradient id="capGrad" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="5%" stopColor="#4D7C0F" stopOpacity={0.2} />
                        <stop offset="95%" stopColor="#4D7C0F" stopOpacity={0.0} />
                      </linearGradient>
                    </defs>
                    <CartesianGrid strokeDasharray="3 3" stroke="#E5DDD0" vertical={false} />
                    <XAxis dataKey="month" tick={{ fontSize: 11, fill: "#897267" }} stroke="#D6C7B2" />
                    <YAxis tick={{ fontSize: 11, fill: "#897267" }} stroke="#D6C7B2" />
                    <Tooltip
                      contentStyle={{
                        backgroundColor: "#FFFFFF",
                        borderColor: "#D6C7B2",
                        borderRadius: "4px",
                        fontSize: "12px",
                      }}
                    />
                    <Legend wrapperStyle={{ fontSize: "11px", paddingTop: "8px" }} />
                    <Area
                      type="monotone"
                      dataKey="projectedDemand"
                      name="Projected Client Demand"
                      stroke="#C2410C"
                      strokeWidth={2.5}
                      fillOpacity={1}
                      fill="url(#demandGrad)"
                    />
                    <Area
                      type="monotone"
                      dataKey="currentCapacity"
                      name="Active Guild Capacity"
                      stroke="#4D7C0F"
                      strokeWidth={2}
                      fillOpacity={1}
                      fill="url(#capGrad)"
                    />
                  </AreaChart>
                </ResponsiveContainer>
              </div>
            </div>

            {/* Chart 2: Trade Shortfall Breakdown */}
            <div className="lg:col-span-5 bg-surface-container-lowest border border-line-hairline p-5 rounded-DEFAULT ledger-offset-shadow space-y-4">
              <div className="flex items-center justify-between border-b border-line-hairline pb-3">
                <div>
                  <span className="text-[10px] uppercase font-bold tracking-wider text-outline block">
                    Trade Requirements
                  </span>
                  <h3 className="font-headline text-base font-semibold text-on-surface">
                    Recommended Enrolment Target
                  </h3>
                </div>
                <span className="font-mono text-xs text-primary font-bold">Q3-Q4 Peak</span>
              </div>

              <div className="space-y-2.5 max-h-72 overflow-y-auto">
                {tradeForecast.map((item, i) => (
                  <div
                    key={i}
                    className="p-2.5 bg-surface-container-low border border-line-hairline rounded-sm flex items-center justify-between text-xs"
                  >
                    <div>
                      <span className="font-bold text-on-surface block">{item.trade}</span>
                      <span className="text-[11px] text-outline">
                        Current: {item.currentActive} · Needed: {item.projectedNeeded}
                      </span>
                    </div>
                    <div className="text-right">
                      <span className="font-mono font-bold text-[#C2410C] block">{item.surge}</span>
                      <span className="text-[10px] text-tertiary">Deficit Target</span>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
