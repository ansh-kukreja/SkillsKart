import React, { useState } from "react";
import { Modal } from "./Modal";
import { Button } from "./Button";
import { useApp } from "../../context/AppContext";

interface ExportModalProps {
  isOpen: boolean;
  onClose: () => void;
  datasetName: "Workers" | "Societies" | "Emergency_SOS" | "Bulk_Requests" | "Audit_Log";
  data: any[];
}

export const ExportModal: React.FC<ExportModalProps> = ({
  isOpen,
  onClose,
  datasetName,
  data,
}) => {
  const { currentNode, currentAccount } = useApp();
  const [viewMode, setViewMode] = useState<"csv" | "ledger_print">("csv");

  const downloadCSV = () => {
    if (!data || data.length === 0) return;

    // Extract headers
    const keys = Object.keys(data[0]).filter((k) => typeof data[0][k] !== "object");
    const headerRow = keys.join(",");
    const rows = data.map((item) =>
      keys
        .map((k) => {
          const val = item[k] ?? "";
          return `"${String(val).replace(/"/g, '""')}"`;
        })
        .join(",")
    );

    const csvContent = "data:text/csv;charset=utf-8," + [headerRow, ...rows].join("\n");
    const encodedUri = encodeURI(csvContent);
    const link = document.createElement("a");
    link.setAttribute("href", encodedUri);
    link.setAttribute(
      "download",
      `SkillsKart_${datasetName}_${currentNode?.code || "LEDGER"}_${new Date().toISOString().slice(0, 10)}.csv`
    );
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    onClose();
  };

  const handlePrint = () => {
    window.print();
  };

  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title="Official Ledger Export & Gazette Generation"
      subtitle={`Exporting ${data.length} records under jurisdiction: ${currentNode?.name || "Apex Directorate"}`}
      maxWidth="2xl"
    >
      <div className="space-y-4">
        {/* Toggle Format */}
        <div className="flex items-center gap-2 pb-3 border-b border-line-hairline">
          <Button
            variant={viewMode === "csv" ? "primary" : "outlined"}
            size="sm"
            icon="table_view"
            onClick={() => setViewMode("csv")}
          >
            Raw CSV Dataset
          </Button>
          <Button
            variant={viewMode === "ledger_print" ? "primary" : "outlined"}
            size="sm"
            icon="description"
            onClick={() => setViewMode("ledger_print")}
          >
            Official Gazette Preview (Print / PDF)
          </Button>
        </div>

        {viewMode === "csv" ? (
          <div className="space-y-4">
            <div className="bg-surface-container-low border border-line-hairline p-3 rounded-sm text-xs text-on-surface-variant">
              <p className="font-semibold text-on-surface mb-1">
                CSV Export Specification:
              </p>
              <ul className="list-disc list-inside space-y-0.5">
                <li>Compatible with Microsoft Excel, LibreOffice Calc, and Google Sheets.</li>
                <li>UTF-8 encoded with standard comma separators.</li>
                <li>Total columns: {data[0] ? Object.keys(data[0]).length : 0} fields per record.</li>
              </ul>
            </div>

            <div className="max-h-48 overflow-x-auto overflow-y-auto border border-line-hairline bg-surface-container-lowest p-2 rounded-sm text-[11px] font-mono text-outline">
              <div className="whitespace-pre">
                {data.slice(0, 5).map((row, idx) => (
                  <div key={idx} className="truncate border-b border-outline-variant/30 py-0.5">
                    {Object.values(row).filter((v) => typeof v !== "object").slice(0, 6).join(" | ")}
                  </div>
                ))}
                {data.length > 5 && (
                  <div className="text-tertiary pt-1 italic">
                    + {data.length - 5} more records included in the file...
                  </div>
                )}
              </div>
            </div>

            <div className="flex justify-end gap-2 pt-2">
              <Button variant="outlined" size="md" onClick={onClose}>
                Cancel
              </Button>
              <Button variant="primary" size="md" icon="download" onClick={downloadCSV}>
                Download .CSV File ({data.length} Records)
              </Button>
            </div>
          </div>
        ) : (
          <div className="space-y-4">
            {/* Printable Gazette Sheet */}
            <div className="border border-line-hairline bg-white p-6 rounded-sm shadow-sm space-y-4 text-on-surface">
              {/* Official Seal Header */}
              <div className="flex items-center justify-between border-b-2 border-primary-container pb-3">
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-sm bg-primary-container text-white flex items-center justify-center font-bold">
                    <span className="material-symbols-outlined text-2xl">account_balance</span>
                  </div>
                  <div>
                    <h4 className="font-headline font-bold text-sm tracking-tight text-primary-container">
                      SkillsKart Blue-Collar Cooperative Ledger
                    </h4>
                    <span className="text-[10px] font-body text-outline uppercase tracking-wider block">
                      Under Multi-State Cooperative Societies Act · Statutory Report
                    </span>
                  </div>
                </div>
                <div className="text-right text-[11px] font-mono">
                  <div>Date: {new Date().toLocaleDateString("en-IN")}</div>
                  <div className="text-tertiary font-semibold">REF: {currentNode?.code || "APX-001"}</div>
                </div>
              </div>

              {/* Jurisdictional Meta */}
              <div className="grid grid-cols-3 gap-2 py-2 text-xs bg-surface-container-low p-2 rounded-sm border border-line-hairline">
                <div>
                  <span className="text-outline block text-[10px] uppercase font-bold">Node Tier:</span>
                  <span className="font-semibold text-on-surface uppercase">{currentAccount?.tier || "APEX"}</span>
                </div>
                <div>
                  <span className="text-outline block text-[10px] uppercase font-bold">Designated Authority:</span>
                  <span className="font-semibold text-on-surface">{currentAccount?.officerName || "Registrar"}</span>
                </div>
                <div>
                  <span className="text-outline block text-[10px] uppercase font-bold">Jurisdiction:</span>
                  <span className="font-semibold text-on-surface truncate block">{currentNode?.region || "National"}</span>
                </div>
              </div>

              {/* Sample Table */}
              <div className="text-xs">
                <div className="font-bold text-xs uppercase tracking-wider text-outline mb-1">
                  Ledger Registry Excerpt ({datasetName})
                </div>
                <table className="w-full text-left border-collapse border border-line-hairline">
                  <thead>
                    <tr className="bg-surface-container-high border-b border-line-hairline text-[10px] uppercase tracking-wider text-outline">
                      <th className="p-1.5 border-r border-line-hairline">#</th>
                      <th className="p-1.5 border-r border-line-hairline">Name / Title</th>
                      <th className="p-1.5 border-r border-line-hairline">Trade / Area</th>
                      <th className="p-1.5 border-r border-line-hairline">Status</th>
                      <th className="p-1.5">ID / Code</th>
                    </tr>
                  </thead>
                  <tbody>
                    {data.slice(0, 6).map((item, i) => (
                      <tr key={i} className="border-b border-line-hairline text-[11px]">
                        <td className="p-1.5 border-r border-line-hairline font-mono">{i + 1}</td>
                        <td className="p-1.5 border-r border-line-hairline font-semibold">
                          {item.name || item.title || item.workerName || "Record"}
                        </td>
                        <td className="p-1.5 border-r border-line-hairline">
                          {item.trade || item.region || item.requiredTrade || item.actionType || "-"}
                        </td>
                        <td className="p-1.5 border-r border-line-hairline font-semibold text-tertiary">
                          {item.status || "Active"}
                        </td>
                        <td className="p-1.5 font-mono text-[10px] text-outline">
                          {item.id || item.code}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>

              {/* Signatures */}
              <div className="pt-4 flex justify-between items-end text-[10px] text-outline">
                <div>
                  <div>Cryptographic Ledger Seal: 0x7F...8A9B</div>
                  <div>Direct Provident Bank Verification: Certified</div>
                </div>
                <div className="text-center border-t border-outline-variant pt-1 w-44">
                  <span className="font-bold text-on-surface block">{currentAccount?.officerName}</span>
                  <span>Authorised Cooperative Signatory</span>
                </div>
              </div>
            </div>

            <div className="flex justify-end gap-2 pt-2">
              <Button variant="outlined" size="md" onClick={onClose}>
                Close
              </Button>
              <Button variant="inverted" size="md" icon="print" onClick={handlePrint}>
                Print / Save as PDF
              </Button>
            </div>
          </div>
        )}
      </div>
    </Modal>
  );
};
