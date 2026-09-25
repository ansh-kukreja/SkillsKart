import React, { useState } from "react";
import { useApp } from "../context/AppContext";
import { FederationBasePrice, SocietyServiceTaskPrice, BlueCollarTrade } from "../types";
import { Button } from "../components/common/Button";
import { Badge } from "../components/common/Badge";
import { Modal } from "../components/common/Modal";
import { ExportModal } from "../components/common/ExportModal";

export const RateCardsScreen: React.FC = () => {
  const {
    isFederation,
    currentNode,
    federationBasePrices,
    updateFederationBasePrice,
    societyTaskPrices,
    scopedSocietyTaskPrices,
    updateSocietyTaskPrice,
    addSocietyTaskPrice,
  } = useApp();

  // Active Tab: default based on active role
  const [activeTab, setActiveTab] = useState<"federation-base" | "society-tasks">(
    isFederation ? "federation-base" : "society-tasks"
  );

  const [isExportOpen, setIsExportOpen] = useState(false);

  // Federation Base Price editing state
  const [editingBasePrice, setEditingBasePrice] = useState<FederationBasePrice | null>(null);
  const [newBaseHourly, setNewBaseHourly] = useState<number>(360);
  const [newFloorRate, setNewFloorRate] = useState<number>(280);
  const [newCeilingRate, setNewCeilingRate] = useState<number>(520);
  const [newVisitCharge, setNewVisitCharge] = useState<number>(150);

  // Society Task Price editing state
  const [editingTaskPrice, setEditingTaskPrice] = useState<SocietyServiceTaskPrice | null>(null);
  const [newTaskPriceValue, setNewTaskPriceValue] = useState<number>(180);

  // Add new task state
  const [isAddTaskOpen, setIsAddTaskOpen] = useState(false);
  const [newTaskName, setNewTaskName] = useState("");
  const [newTaskCategory, setNewTaskCategory] = useState("Sanitary Fittings");
  const [newTaskTrade, setNewTaskTrade] = useState<BlueCollarTrade>("Plumbing & Sanitation");
  const [newTaskDuration, setNewTaskDuration] = useState(30);
  const [newTaskPrice, setNewTaskPrice] = useState(220);
  const [newTaskDesc, setNewTaskDesc] = useState("");

  const handleSaveBasePrice = () => {
    if (!editingBasePrice) return;
    updateFederationBasePrice(editingBasePrice.id, {
      baseHourlyRate: newBaseHourly,
      minFloorRate: newFloorRate,
      maxCeilingRate: newCeilingRate,
      recommendedVisitCharge: newVisitCharge,
    });
    setEditingBasePrice(null);
  };

  const handleSaveTaskPrice = () => {
    if (!editingTaskPrice) return;
    updateSocietyTaskPrice(editingTaskPrice.id, newTaskPriceValue);
    setEditingTaskPrice(null);
  };

  const handleCreateTask = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newTaskName.trim()) return;

    addSocietyTaskPrice({
      societyId: currentNode?.id || "soc-plumbers-pune",
      trade: newTaskTrade,
      taskName: newTaskName,
      category: newTaskCategory,
      description: newTaskDesc || "Standard society certified repair procedure.",
      estimatedDurationMins: Number(newTaskDuration),
      price: Number(newTaskPrice),
      materialCostPolicy: "Labor only (Customer provides parts)",
      federationBaseFloor: Math.round(Number(newTaskPrice) * 0.75),
      federationBaseCeiling: Math.round(Number(newTaskPrice) * 1.5),
      status: "Active",
      isPopular: false,
    });

    setNewTaskName("");
    setNewTaskDesc("");
    setIsAddTaskOpen(false);
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-stone-200/80">
        <div>
          <div className="flex items-center gap-2 mb-1">
            <span className="text-[10px] uppercase font-bold tracking-widest text-amber-900 bg-amber-100 px-2.5 py-0.5 rounded-full border border-amber-300/60">
              Cooperative Tariff Architecture
            </span>
            <span className="text-stone-400">·</span>
            <Badge tone="olive" size="sm">
              State Living Wage Benchmark
            </Badge>
          </div>
          <h1 className="font-headline text-2xl sm:text-3xl font-bold text-stone-900 tracking-tight">
            Service Rate Cards & Wage Schedules
          </h1>
          <p className="font-body text-xs sm:text-sm text-stone-600 mt-0.5">
            Democratic, two-tiered tariff system: Federations establish statutory base price bands; Societies configure particular work item rates (e.g. Tap Replacement, Shower change).
          </p>
        </div>

        <div className="flex items-center gap-2.5">
          <Button
            variant="outlined"
            size="md"
            icon="file_download"
            className="rounded-xl text-xs"
            onClick={() => setIsExportOpen(true)}
          >
            Export Tariff Sheet
          </Button>

          {activeTab === "society-tasks" && (
            <Button
              variant="primary"
              size="md"
              icon="add_circle"
              className="rounded-xl text-xs font-bold"
              onClick={() => setIsAddTaskOpen(true)}
            >
              Add Work Item
            </Button>
          )}
        </div>
      </div>

      {/* Tabs: Federation Base Tariffs vs Society Particular Work Tasks */}
      <div className="flex rounded-xl bg-stone-100 p-1 border border-stone-200 text-xs font-bold max-w-lg">
        <button
          type="button"
          onClick={() => setActiveTab("federation-base")}
          className={`flex-1 py-2 px-3 rounded-lg transition-all flex items-center justify-center gap-2 ${
            activeTab === "federation-base"
              ? "bg-white text-amber-900 shadow-xs border border-stone-200"
              : "text-stone-600 hover:text-stone-900"
          }`}
        >
          <span className="material-symbols-outlined text-base">account_balance</span>
          <span>1. Federation Base Tariffs</span>
        </button>
        <button
          type="button"
          onClick={() => setActiveTab("society-tasks")}
          className={`flex-1 py-2 px-3 rounded-lg transition-all flex items-center justify-center gap-2 ${
            activeTab === "society-tasks"
              ? "bg-white text-amber-900 shadow-xs border border-stone-200"
              : "text-stone-600 hover:text-stone-900"
          }`}
        >
          <span className="material-symbols-outlined text-base">sell</span>
          <span>2. Society Task Rates (Tap, Shower...)</span>
        </button>
      </div>

      {/* TAB 1: FEDERATION STATUTORY BASE PRICING */}
      {activeTab === "federation-base" && (
        <div className="space-y-4">
          <div className="p-4 rounded-xl bg-amber-50/70 border border-amber-200 text-xs text-amber-950 flex items-start gap-3">
            <span className="material-symbols-outlined text-amber-800 text-lg mt-0.5 shrink-0">
              gavel
            </span>
            <div className="space-y-0.5 leading-relaxed">
              <span className="font-bold block">
                Statutory Wage Floor Accord (Multi-State Co-op Regulatory Mechanism):
              </span>
              <p>
                Federations define statutory floor tariffs anchored to legitimate State Labour Gazette minimum-wage notifications. Member societies cannot price service work items below this floor, eliminating algorithmic wage suppression.
              </p>
            </div>
          </div>

          <div className="bg-white border border-stone-200/90 rounded-2xl shadow-xs overflow-hidden">
            <div className="overflow-x-auto">
              <table className="w-full text-left border-collapse text-xs">
                <thead>
                  <tr className="bg-stone-50/80 border-b border-stone-200 text-[11px] uppercase tracking-wider text-stone-500 font-bold">
                    <th className="py-3 px-4">Trade Specification</th>
                    <th className="py-3 px-4">Statutory Reference</th>
                    <th className="py-3 px-4 text-center">Minimum Floor Rate</th>
                    <th className="py-3 px-4 text-center">Standard Base Hourly</th>
                    <th className="py-3 px-4 text-center">Ceiling Cap</th>
                    <th className="py-3 px-4 text-center">Inspection/Visit Fee</th>
                    <th className="py-3 px-4 text-right">Actions</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-stone-100">
                  {federationBasePrices.map((bp) => (
                    <tr key={bp.id} className="hover:bg-amber-50/30 transition-colors">
                      <td className="py-3.5 px-4">
                        <span className="font-bold text-stone-900 block text-xs sm:text-sm">
                          {bp.trade}
                        </span>
                        <span className="text-[11px] text-stone-500 font-mono">
                          Category: {bp.category}
                        </span>
                      </td>

                      <td className="py-3.5 px-4 text-stone-600">
                        <span className="font-mono text-xs block">{bp.statutoryWageRef}</span>
                        <span className="text-[10px] text-stone-400">Audited {bp.lastUpdated}</span>
                      </td>

                      <td className="py-3.5 px-4 text-center">
                        <span className="font-mono font-bold text-amber-900 text-sm bg-amber-50 px-2 py-0.5 rounded-md border border-amber-200">
                          ₹{bp.minFloorRate}/hr
                        </span>
                        <span className="text-[10px] text-stone-400 block mt-0.5">Statutory Floor</span>
                      </td>

                      <td className="py-3.5 px-4 text-center">
                        <span className="font-mono font-bold text-stone-900 text-sm">
                          ₹{bp.baseHourlyRate}/hr
                        </span>
                        <span className="text-[10px] text-stone-500 block mt-0.5">Benchmark</span>
                      </td>

                      <td className="py-3.5 px-4 text-center font-mono font-semibold text-stone-700">
                        ₹{bp.maxCeilingRate}/hr
                      </td>

                      <td className="py-3.5 px-4 text-center font-mono font-bold text-emerald-800">
                        ₹{bp.recommendedVisitCharge}
                      </td>

                      <td className="py-3.5 px-4 text-right">
                        <Button
                          variant="outlined"
                          size="sm"
                          icon="edit"
                          className="rounded-lg text-xs"
                          onClick={() => {
                            setEditingBasePrice(bp);
                            setNewBaseHourly(bp.baseHourlyRate);
                            setNewFloorRate(bp.minFloorRate);
                            setNewCeilingRate(bp.maxCeilingRate);
                            setNewVisitCharge(bp.recommendedVisitCharge);
                          }}
                        >
                          Set Base Price
                        </Button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      )}

      {/* TAB 2: SOCIETY PARTICULAR WORK ITEM RATES */}
      {activeTab === "society-tasks" && (
        <div className="space-y-4">
          <div className="p-4 rounded-xl bg-orange-50/70 border border-orange-200 text-xs text-orange-950 flex items-start gap-3">
            <span className="material-symbols-outlined text-orange-800 text-lg mt-0.5 shrink-0">
              sell
            </span>
            <div className="space-y-0.5 leading-relaxed">
              <span className="font-bold block">
                Particular Work Item Rates (Configured by Primary Cooperative Societies):
              </span>
              <p>
                Primary societies set distinct task rates for standardized work items like <strong>"Tap Replacement"</strong>, <strong>"Shower change"</strong>, <strong>"Drainage unclogging"</strong>, and <strong>"Switchboard replacement"</strong>. All rates are checked against Federation Price Bands.
              </p>
            </div>
          </div>

          {/* Task Grid */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {(isFederation ? societyTaskPrices : scopedSocietyTaskPrices).map((task) => (
              <div
                key={task.id}
                className="p-4 rounded-xl border border-stone-200/90 bg-white hover:border-amber-700/40 hover:shadow-md transition-all flex flex-col justify-between space-y-3"
              >
                <div>
                  <div className="flex items-start justify-between gap-2">
                    <div>
                      <span className="text-[10px] uppercase font-bold tracking-wider text-amber-800 bg-amber-100/70 px-2 py-0.5 rounded-md">
                        {task.category}
                      </span>
                      <h3 className="font-bold text-sm text-stone-900 mt-1.5">
                        {task.taskName}
                      </h3>
                    </div>
                    {task.isPopular && (
                      <span className="text-[9px] font-bold uppercase tracking-wider px-1.5 py-0.5 rounded bg-orange-100 text-orange-800 border border-orange-200">
                        Popular
                      </span>
                    )}
                  </div>

                  <p className="text-xs text-stone-600 mt-2 leading-relaxed line-clamp-2">
                    {task.description}
                  </p>

                  <div className="mt-3 flex items-center justify-between text-xs text-stone-500 pt-2 border-t border-stone-100">
                    <span className="flex items-center gap-1 font-medium">
                      <span className="material-symbols-outlined text-stone-400 text-sm">timer</span>
                      <span>{task.estimatedDurationMins} mins</span>
                    </span>
                    <span className="text-[11px] text-stone-600">
                      {task.materialCostPolicy}
                    </span>
                  </div>
                </div>

                {/* Price & Action */}
                <div className="pt-2.5 border-t border-stone-100 flex items-center justify-between">
                  <div>
                    <span className="text-[10px] uppercase font-bold text-stone-400 block">
                      Society Tariff
                    </span>
                    <span className="font-headline font-bold text-xl text-stone-900">
                      ₹{task.price}
                    </span>
                  </div>

                  <div className="text-right space-y-1">
                    <span className="text-[10px] text-emerald-700 font-bold block">
                      Band: ₹{task.federationBaseFloor} - ₹{task.federationBaseCeiling}
                    </span>
                    <Button
                      variant="outlined"
                      size="sm"
                      icon="edit"
                      className="rounded-lg text-xs"
                      onClick={() => {
                        setEditingTaskPrice(task);
                        setNewTaskPriceValue(task.price);
                      }}
                    >
                      Set Price
                    </Button>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* EDIT FEDERATION BASE PRICE MODAL */}
      {editingBasePrice && (
        <Modal
          isOpen={true}
          onClose={() => setEditingBasePrice(null)}
          title={`Set Federation Base Tariff: ${editingBasePrice.trade}`}
          subtitle={`Statutory schedule anchored to ${editingBasePrice.statutoryWageRef}`}
          maxWidth="md"
        >
          <div className="space-y-4">
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3.5">
              <div>
                <label className="block text-xs font-bold text-stone-800 mb-1">
                  Standard Base Hourly Rate (₹) *
                </label>
                <input
                  type="number"
                  min={100}
                  max={2000}
                  step={10}
                  value={newBaseHourly}
                  onChange={(e) => setNewBaseHourly(Number(e.target.value))}
                  className="w-full bg-stone-50 border border-stone-300 rounded-xl px-3 py-2 text-sm font-bold text-stone-900 focus:outline-none focus:border-amber-700 font-mono"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-stone-800 mb-1">
                  Mandatory Floor Rate (₹) *
                </label>
                <input
                  type="number"
                  min={100}
                  max={newBaseHourly}
                  step={10}
                  value={newFloorRate}
                  onChange={(e) => setNewFloorRate(Number(e.target.value))}
                  className="w-full bg-stone-50 border border-stone-300 rounded-xl px-3 py-2 text-sm font-bold text-stone-900 focus:outline-none focus:border-amber-700 font-mono"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-stone-800 mb-1">
                  Ceiling Cap Rate (₹) *
                </label>
                <input
                  type="number"
                  min={newBaseHourly}
                  max={3000}
                  step={10}
                  value={newCeilingRate}
                  onChange={(e) => setNewCeilingRate(Number(e.target.value))}
                  className="w-full bg-stone-50 border border-stone-300 rounded-xl px-3 py-2 text-sm font-bold text-stone-900 focus:outline-none focus:border-amber-700 font-mono"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-stone-800 mb-1">
                  Recommended Visit Fee (₹) *
                </label>
                <input
                  type="number"
                  min={50}
                  max={500}
                  step={10}
                  value={newVisitCharge}
                  onChange={(e) => setNewVisitCharge(Number(e.target.value))}
                  className="w-full bg-stone-50 border border-stone-300 rounded-xl px-3 py-2 text-sm font-bold text-stone-900 focus:outline-none focus:border-amber-700 font-mono"
                />
              </div>
            </div>

            <div className="flex justify-end gap-2.5 pt-3 border-t border-stone-200">
              <Button
                variant="outlined"
                size="md"
                className="rounded-xl text-xs"
                onClick={() => setEditingBasePrice(null)}
              >
                Cancel
              </Button>
              <Button
                variant="primary"
                size="md"
                icon="check"
                className="rounded-xl text-xs font-bold"
                onClick={handleSaveBasePrice}
              >
                Save Base Tariff
              </Button>
            </div>
          </div>
        </Modal>
      )}

      {/* EDIT SOCIETY TASK PRICE MODAL */}
      {editingTaskPrice && (
        <Modal
          isOpen={true}
          onClose={() => setEditingTaskPrice(null)}
          title={`Set Task Price: ${editingTaskPrice.taskName}`}
          subtitle={`Current Rate: ₹${editingTaskPrice.price} · Trade: ${editingTaskPrice.trade}`}
          maxWidth="sm"
        >
          <div className="space-y-4">
            <div>
              <label className="block text-xs font-bold text-stone-800 mb-1">
                Customer Task Price (₹) *
              </label>
              <input
                type="number"
                min={editingTaskPrice.federationBaseFloor}
                max={editingTaskPrice.federationBaseCeiling * 1.5}
                step={10}
                value={newTaskPriceValue}
                onChange={(e) => setNewTaskPriceValue(Number(e.target.value))}
                className="w-full bg-stone-50 border border-stone-300 rounded-xl px-3 py-2 text-base font-bold text-stone-900 focus:outline-none focus:border-amber-700 font-mono"
              />
            </div>

            <div className="p-3 rounded-xl bg-stone-50 border border-stone-200 text-xs space-y-1">
              <div className="flex items-center justify-between">
                <span className="text-stone-500">Federation Price Band:</span>
                <span className="font-mono font-bold text-stone-800">
                  ₹{editingTaskPrice.federationBaseFloor} - ₹{editingTaskPrice.federationBaseCeiling}
                </span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-stone-500">Compliance Status:</span>
                <span
                  className={`font-bold ${
                    newTaskPriceValue >= editingTaskPrice.federationBaseFloor &&
                    newTaskPriceValue <= editingTaskPrice.federationBaseCeiling
                      ? "text-emerald-700"
                      : "text-amber-800"
                  }`}
                >
                  {newTaskPriceValue >= editingTaskPrice.federationBaseFloor &&
                  newTaskPriceValue <= editingTaskPrice.federationBaseCeiling
                    ? "✓ Compliant with Federation Band"
                    : "⚠️ Deviation recorded in audit ledger"}
                </span>
              </div>
            </div>

            <div className="flex justify-end gap-2.5 pt-2">
              <Button
                variant="outlined"
                size="md"
                className="rounded-xl text-xs"
                onClick={() => setEditingTaskPrice(null)}
              >
                Cancel
              </Button>
              <Button
                variant="primary"
                size="md"
                icon="check"
                className="rounded-xl text-xs font-bold"
                onClick={handleSaveTaskPrice}
              >
                Update Task Price
              </Button>
            </div>
          </div>
        </Modal>
      )}

      {/* ADD WORK ITEM MODAL */}
      {isAddTaskOpen && (
        <Modal
          isOpen={true}
          onClose={() => setIsAddTaskOpen(false)}
          title="Add New Specific Work Item"
          subtitle="Configure a new task rate (e.g. Tap Replacement, Shower change, Cistern overhaul)"
          maxWidth="md"
        >
          <form onSubmit={handleCreateTask} className="space-y-4">
            <div>
              <label className="block text-xs font-bold text-stone-800 mb-1">
                Work Item / Task Name *
              </label>
              <input
                type="text"
                required
                placeholder="e.g. Overhead Tank Float Valve Replacement"
                value={newTaskName}
                onChange={(e) => setNewTaskName(e.target.value)}
                className="w-full bg-stone-50 border border-stone-300 rounded-xl px-3 py-2 text-xs text-stone-900 focus:outline-none focus:border-amber-700"
              />
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
              <div>
                <label className="block text-xs font-bold text-stone-800 mb-1">
                  Trade *
                </label>
                <select
                  value={newTaskTrade}
                  onChange={(e) => setNewTaskTrade(e.target.value as BlueCollarTrade)}
                  className="w-full bg-stone-50 border border-stone-300 rounded-xl px-3 py-2 text-xs text-stone-900 focus:outline-none focus:border-amber-700"
                >
                  <option value="Plumbing & Sanitation">Plumbing & Sanitation (Plumbers)</option>
                  <option value="Electrical & Wiring">Electrical & Wiring (Electricians)</option>
                  <option value="Gardening & Landscaping">Gardening & Landscaping (Gardeners)</option>
                  <option value="Caregiving & Elder Care">Caregiving & Elder Care (Caregivers)</option>
                  <option value="Appliance Repair & HVAC">Appliance Repair & HVAC</option>
                  <option value="Carpentry & Woodwork">Carpentry & Woodwork</option>
                  <option value="Painting & Waterproofing">Painting & Waterproofing</option>
                </select>
              </div>

              <div>
                <label className="block text-xs font-bold text-stone-800 mb-1">
                  Category *
                </label>
                <input
                  type="text"
                  required
                  placeholder="e.g. Faucets & Valves"
                  value={newTaskCategory}
                  onChange={(e) => setNewTaskCategory(e.target.value)}
                  className="w-full bg-stone-50 border border-stone-300 rounded-xl px-3 py-2 text-xs text-stone-900 focus:outline-none focus:border-amber-700"
                />
              </div>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
              <div>
                <label className="block text-xs font-bold text-stone-800 mb-1">
                  Standard Customer Price (₹) *
                </label>
                <input
                  type="number"
                  min={50}
                  max={5000}
                  step={10}
                  value={newTaskPrice}
                  onChange={(e) => setNewTaskPrice(Number(e.target.value))}
                  className="w-full bg-stone-50 border border-stone-300 rounded-xl px-3 py-2 text-sm font-bold text-stone-900 focus:outline-none focus:border-amber-700 font-mono"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-stone-800 mb-1">
                  Duration (Mins) *
                </label>
                <input
                  type="number"
                  min={10}
                  max={480}
                  step={5}
                  value={newTaskDuration}
                  onChange={(e) => setNewTaskDuration(Number(e.target.value))}
                  className="w-full bg-stone-50 border border-stone-300 rounded-xl px-3 py-2 text-xs text-stone-900 focus:outline-none focus:border-amber-700 font-mono"
                />
              </div>
            </div>

            <div>
              <label className="block text-xs font-bold text-stone-800 mb-1">
                Task Scope & Quality Description
              </label>
              <textarea
                rows={2}
                placeholder="Scope of work, standard consumables policy, and diagnostic test..."
                value={newTaskDesc}
                onChange={(e) => setNewTaskDesc(e.target.value)}
                className="w-full bg-stone-50 border border-stone-300 rounded-xl p-3 text-xs text-stone-900 focus:outline-none focus:border-amber-700"
              />
            </div>

            <div className="flex justify-end gap-2.5 pt-2 border-t border-stone-200">
              <Button
                variant="outlined"
                size="md"
                className="rounded-xl text-xs"
                onClick={() => setIsAddTaskOpen(false)}
              >
                Cancel
              </Button>
              <Button
                variant="primary"
                size="md"
                icon="check"
                className="rounded-xl text-xs font-bold"
              >
                Save Work Item
              </Button>
            </div>
          </form>
        </Modal>
      )}

      {/* Export Modal */}
      <ExportModal
        isOpen={isExportOpen}
        onClose={() => setIsExportOpen(false)}
        datasetName="Workers"
        data={societyTaskPrices}
      />
    </div>
  );
};
