import React, { useState } from "react";
import { useApp } from "../context/AppContext";
import { Button } from "../components/common/Button";
import { Badge } from "../components/common/Badge";
import { Modal } from "../components/common/Modal";
import { ExportModal } from "../components/common/ExportModal";
import { BlueCollarTrade } from "../types";

const TRADE_OPTIONS: BlueCollarTrade[] = [
  "Electrical & Wiring",
  "Plumbing & Sanitation",
  "Appliance Repair & HVAC",
  "Carpentry & Assembly",
  "Masonry & Civil Repairs",
  "Painting & Waterproofing",
  "Facility Cleaning & Pest Control",
  "Commercial Equipment Maintenance",
];

export const HierarchyScreen: React.FC = () => {
  const {
    currentNode,
    currentAccount,
    scopedManagedNodes,
    scopedWorkers,
    addChildNode,
    addWorker,
  } = useApp();

  const [isAddOpen, setIsAddOpen] = useState(false);
  const [isExportOpen, setIsExportOpen] = useState(false);
  const [searchFilter, setSearchFilter] = useState("");

  // Determine what level this node manages
  const tier = currentNode?.tier || "national";
  const isSocietyLevel = tier === "society";

  // Form states
  const [name, setName] = useState("");
  const [contactPerson, setContactPerson] = useState("");
  const [contactPhone, setContactPhone] = useState("");
  const [region, setRegion] = useState("");

  // Worker specific form states (if society)
  const [trade, setTrade] = useState<BlueCollarTrade>("Electrical & Wiring");
  const [experienceYears, setExperienceYears] = useState<number>(5);

  const getManagedEntityLabel = () => {
    switch (tier) {
      case "national":
        return { singular: "Federation", plural: "Federations", verb: "Add Federation Node" };
      case "federation":
        return { singular: "Primary Society", plural: "Primary Societies", verb: "Add Primary Society" };
      case "society":
        return { singular: "Enrolled Worker", plural: "Enrolled Workers", verb: "Add Skilled Worker" };
      default:
        return { singular: "Child Node", plural: "Child Nodes", verb: "Add Entity" };
    }
  };

  const labelConfig = getManagedEntityLabel();

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!name.trim()) return;

    if (isSocietyLevel) {
      addWorker({
        name,
        trade,
        phone: contactPhone || "+91 98000 00000",
        experienceYears,
        locationCluster: region || "Local Sub-cluster",
      });
    } else {
      addChildNode({
        name,
        contactPerson: contactPerson || "Designated Registrar",
        contactPhone: contactPhone || "+91 20 2000 0000",
        region: region || "District Jurisdiction",
      });
    }

    // Reset form
    setName("");
    setContactPerson("");
    setContactPhone("");
    setRegion("");
    setIsAddOpen(false);
  };

  // Filtered rows
  const filteredNodes = scopedManagedNodes.filter(
    (n) =>
      n.name.toLowerCase().includes(searchFilter.toLowerCase()) ||
      n.code.toLowerCase().includes(searchFilter.toLowerCase()) ||
      n.contactPerson.toLowerCase().includes(searchFilter.toLowerCase()) ||
      n.region.toLowerCase().includes(searchFilter.toLowerCase())
  );

  const filteredWorkers = scopedWorkers.filter(
    (w) =>
      w.name.toLowerCase().includes(searchFilter.toLowerCase()) ||
      w.trade.toLowerCase().includes(searchFilter.toLowerCase()) ||
      w.phone.includes(searchFilter) ||
      w.locationCluster.toLowerCase().includes(searchFilter.toLowerCase())
  );

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-line-hairline">
        <div>
          <div className="flex items-center gap-2 mb-1">
            <span className="text-[10px] uppercase font-bold tracking-widest text-[#B45309]">
              Delegated Hierarchy
            </span>
            <span className="text-outline">·</span>
            <Badge tone="olive" size="sm">
              Direct Active Entry
            </Badge>
          </div>
          <h1 className="font-headline text-2xl sm:text-3xl font-semibold text-on-surface tracking-tight">
            Hierarchy Management: {labelConfig.plural}
          </h1>
          <p className="font-body text-xs text-on-surface-variant mt-0.5">
            Administers all direct child entities under <strong className="text-on-surface">{currentNode?.name}</strong>. Entries are immediately Active with full ledger capabilities.
          </p>
        </div>

        <div className="flex items-center gap-2.5">
          <Button
            variant="outlined"
            size="md"
            icon="file_download"
            onClick={() => setIsExportOpen(true)}
          >
            Export Table
          </Button>

          <Button
            variant="primary"
            size="md"
            icon="add_circle"
            onClick={() => setIsAddOpen(true)}
          >
            {labelConfig.verb}
          </Button>
        </div>
      </div>

      {/* Overview Notice */}
      <div className="p-3.5 bg-surface-container-low border border-line-hairline rounded-DEFAULT flex items-center justify-between gap-3 text-xs">
        <div className="flex items-center gap-2">
          <span className="material-symbols-outlined text-primary text-base">info</span>
          <span className="text-on-surface-variant">
            <strong>Streamlined Enrollment Protocol:</strong> Adding new {labelConfig.plural.toLowerCase()} requires only verified institutional coordinates. Entities are granted immediate active status in the cooperative ledger with zero pending delays.
          </span>
        </div>
        <Badge tone="olive" size="sm">
          Instant Active
        </Badge>
      </div>

      {/* Table Section */}
      <div className="bg-surface-container-lowest border border-line-hairline rounded-DEFAULT ledger-offset-shadow overflow-hidden space-y-4 p-4 sm:p-5">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-line-hairline pb-3">
          <div className="flex items-center gap-2">
            <span className="font-bold text-xs uppercase tracking-wider text-on-surface">
              Active {labelConfig.plural} Registry
            </span>
            <span className="bg-surface-container text-on-surface-variant text-[10px] px-1.5 py-0.2 rounded-sm font-bold border border-outline-variant font-mono">
              {isSocietyLevel ? scopedWorkers.length : scopedManagedNodes.length} Total
            </span>
          </div>

          <div className="relative w-full sm:w-64">
            <span className="material-symbols-outlined absolute left-2.5 top-1/2 -translate-y-1/2 text-outline text-sm">
              search
            </span>
            <input
              type="text"
              value={searchFilter}
              onChange={(e) => setSearchFilter(e.target.value)}
              placeholder={`Filter ${labelConfig.plural.toLowerCase()}...`}
              className="w-full bg-surface-container-low border border-line-focused pl-8 pr-3 py-1.5 rounded-sm text-xs font-body text-on-surface placeholder:text-outline focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary"
            />
          </div>
        </div>

        {/* Responsive Table */}
        <div className="overflow-x-auto">
          {isSocietyLevel ? (
            /* Workers Table for Society Level */
            <table className="w-full text-left border-collapse text-xs">
              <thead>
                <tr className="bg-surface-container-high border-b border-line-hairline text-[10px] uppercase tracking-wider text-outline font-bold">
                  <th className="py-2.5 px-3">Technician / Worker</th>
                  <th className="py-2.5 px-3">Trade Specialization</th>
                  <th className="py-2.5 px-3">Experience</th>
                  <th className="py-2.5 px-3">Location Cluster</th>
                  <th className="py-2.5 px-3">Phone / UID</th>
                  <th className="py-2.5 px-3">Status</th>
                  <th className="py-2.5 px-3 text-right">Rating</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-line-hairline">
                {filteredWorkers.length === 0 ? (
                  <tr>
                    <td colSpan={7} className="text-center py-8 text-outline text-xs">
                      No enrolled workers found matching search criteria.
                    </td>
                  </tr>
                ) : (
                  filteredWorkers.map((w) => (
                    <tr key={w.id} className="hover:bg-surface-container-low transition-colors">
                      <td className="py-2.5 px-3">
                        <span className="font-bold text-on-surface block">{w.name}</span>
                        <span className="font-mono text-[10px] text-outline">{w.id}</span>
                      </td>
                      <td className="py-2.5 px-3">
                        <span className="font-semibold text-primary-container block">{w.trade}</span>
                      </td>
                      <td className="py-2.5 px-3 font-mono">{w.experienceYears} Years</td>
                      <td className="py-2.5 px-3 text-on-surface-variant">{w.locationCluster}</td>
                      <td className="py-2.5 px-3 font-mono text-[11px]">{w.phone}</td>
                      <td className="py-2.5 px-3">
                        <Badge tone="olive" size="sm">
                          {w.status}
                        </Badge>
                      </td>
                      <td className="py-2.5 px-3 text-right font-mono font-bold text-tertiary">
                        ★ {w.rating.toFixed(2)}
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          ) : (
            /* Managed Child Nodes Table for National / State / District */
            <table className="w-full text-left border-collapse text-xs">
              <thead>
                <tr className="bg-surface-container-high border-b border-line-hairline text-[10px] uppercase tracking-wider text-outline font-bold">
                  <th className="py-2.5 px-3">Federation / Society Name</th>
                  <th className="py-2.5 px-3">Gazette Code</th>
                  <th className="py-2.5 px-3">Designated Registrar</th>
                  <th className="py-2.5 px-3">Contact Phone</th>
                  <th className="py-2.5 px-3">Jurisdictional Region</th>
                  <th className="py-2.5 px-3">Sub-Societies</th>
                  <th className="py-2.5 px-3">Status</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-line-hairline">
                {filteredNodes.length === 0 ? (
                  <tr>
                    <td colSpan={7} className="text-center py-8 text-outline text-xs">
                      No managed {labelConfig.plural.toLowerCase()} registered under this node yet.
                    </td>
                  </tr>
                ) : (
                  filteredNodes.map((node) => (
                    <tr key={node.id} className="hover:bg-surface-container-low transition-colors">
                      <td className="py-2.5 px-3">
                        <span className="font-bold text-on-surface block">{node.name}</span>
                        <span className="text-[10px] text-outline font-mono uppercase">
                          Est. {node.establishedYear}
                        </span>
                      </td>
                      <td className="py-2.5 px-3 font-mono font-bold text-primary">
                        {node.code}
                      </td>
                      <td className="py-2.5 px-3 text-on-surface font-semibold">
                        {node.contactPerson}
                      </td>
                      <td className="py-2.5 px-3 font-mono text-[11px] text-on-surface-variant">
                        {node.contactPhone}
                      </td>
                      <td className="py-2.5 px-3 text-on-surface-variant">
                        {node.region}
                      </td>
                      <td className="py-2.5 px-3 font-mono text-center">
                        {node.activeSocietiesCount || 1}
                      </td>
                      <td className="py-2.5 px-3">
                        <Badge tone="olive" size="sm">
                          {node.status}
                        </Badge>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          )}
        </div>
      </div>

      {/* Add Entity Modal */}
      <Modal
        isOpen={isAddOpen}
        onClose={() => setIsAddOpen(false)}
        title={`Enroll New ${labelConfig.singular}`}
        subtitle="Registers immediately as Active in the cooperative operational tree"
        maxWidth="lg"
      >
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="space-y-3">
            <div>
              <label className="block text-xs font-bold uppercase tracking-wider text-outline mb-1">
                {isSocietyLevel ? "Technician Full Name" : `${labelConfig.singular} Title / Name`} *
              </label>
              <input
                type="text"
                required
                value={name}
                onChange={(e) => setName(e.target.value)}
                placeholder={isSocietyLevel ? "e.g. Ramesh S. Patil" : `e.g. Pune North Technicians Guild`}
                className="w-full bg-surface-container-low border border-line-focused px-3 py-2 rounded-sm text-xs text-on-surface focus:outline-none focus:border-primary"
              />
            </div>

            {isSocietyLevel ? (
              <>
                <div className="grid grid-cols-2 gap-3">
                  <div>
                    <label className="block text-xs font-bold uppercase tracking-wider text-outline mb-1">
                      Blue-Collar Trade Specialization *
                    </label>
                    <select
                      value={trade}
                      onChange={(e) => setTrade(e.target.value as BlueCollarTrade)}
                      className="w-full bg-surface-container-low border border-line-focused px-3 py-2 rounded-sm text-xs text-on-surface focus:outline-none focus:border-primary"
                    >
                      {TRADE_OPTIONS.map((t) => (
                        <option key={t} value={t}>
                          {t}
                        </option>
                      ))}
                    </select>
                  </div>
                  <div>
                    <label className="block text-xs font-bold uppercase tracking-wider text-outline mb-1">
                      Years of Field Experience *
                    </label>
                    <input
                      type="number"
                      min={1}
                      max={40}
                      value={experienceYears}
                      onChange={(e) => setExperienceYears(Number(e.target.value))}
                      className="w-full bg-surface-container-low border border-line-focused px-3 py-2 rounded-sm text-xs text-on-surface focus:outline-none focus:border-primary"
                    />
                  </div>
                </div>

                <div>
                  <label className="block text-xs font-bold uppercase tracking-wider text-outline mb-1">
                    Contact Mobile Number *
                  </label>
                  <input
                    type="tel"
                    required
                    value={contactPhone}
                    onChange={(e) => setContactPhone(e.target.value)}
                    placeholder="+91 98XXX XXXXX"
                    className="w-full bg-surface-container-low border border-line-focused px-3 py-2 rounded-sm text-xs text-on-surface focus:outline-none focus:border-primary"
                  />
                </div>

                <div>
                  <label className="block text-xs font-bold uppercase tracking-wider text-outline mb-1">
                    Operational Cluster / Hub Area *
                  </label>
                  <input
                    type="text"
                    required
                    value={region}
                    onChange={(e) => setRegion(e.target.value)}
                    placeholder="e.g. Hadapsar Industrial Zone Sector 2"
                    className="w-full bg-surface-container-low border border-line-focused px-3 py-2 rounded-sm text-xs text-on-surface focus:outline-none focus:border-primary"
                  />
                </div>
              </>
            ) : (
              <>
                <div className="grid grid-cols-2 gap-3">
                  <div>
                    <label className="block text-xs font-bold uppercase tracking-wider text-outline mb-1">
                      Designated Registrar / Officer *
                    </label>
                    <input
                      type="text"
                      required
                      value={contactPerson}
                      onChange={(e) => setContactPerson(e.target.value)}
                      placeholder="e.g. Sunita Deshmukh"
                      className="w-full bg-surface-container-low border border-line-focused px-3 py-2 rounded-sm text-xs text-on-surface focus:outline-none focus:border-primary"
                    />
                  </div>
                  <div>
                    <label className="block text-xs font-bold uppercase tracking-wider text-outline mb-1">
                      Contact Telephone *
                    </label>
                    <input
                      type="tel"
                      required
                      value={contactPhone}
                      onChange={(e) => setContactPhone(e.target.value)}
                      placeholder="+91 20 2612 8844"
                      className="w-full bg-surface-container-low border border-line-focused px-3 py-2 rounded-sm text-xs text-on-surface focus:outline-none focus:border-primary"
                    />
                  </div>
                </div>

                <div>
                  <label className="block text-xs font-bold uppercase tracking-wider text-outline mb-1">
                    Jurisdictional Region / District Cluster *
                  </label>
                  <input
                    type="text"
                    required
                    value={region}
                    onChange={(e) => setRegion(e.target.value)}
                    placeholder="e.g. Pune Urban & Industrial Corridor"
                    className="w-full bg-surface-container-low border border-line-focused px-3 py-2 rounded-sm text-xs text-on-surface focus:outline-none focus:border-primary"
                  />
                </div>
              </>
            )}
          </div>

          <div className="p-3 bg-surface-container-low rounded-sm border border-line-hairline text-xs text-on-surface-variant">
            <span className="font-bold text-on-surface block">Ledger Verification Note:</span>
            <span>
              This entity will be appended directly into the active hierarchical tree with immediate dispatch credentials. Zero onboarding verification queue or manual KYC bottleneck.
            </span>
          </div>

          <div className="flex justify-end gap-2 pt-2">
            <Button
              type="button"
              variant="outlined"
              size="md"
              onClick={() => setIsAddOpen(false)}
            >
              Cancel
            </Button>
            <Button type="submit" variant="primary" size="md" icon="check">
              Confirm & Enroll as Active
            </Button>
          </div>
        </form>
      </Modal>

      {/* Export Table Modal */}
      <ExportModal
        isOpen={isExportOpen}
        onClose={() => setIsExportOpen(false)}
        datasetName={isSocietyLevel ? "Workers" : "Societies"}
        data={isSocietyLevel ? scopedWorkers : scopedManagedNodes}
      />
    </div>
  );
};
