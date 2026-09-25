import React from "react";

export type BadgeTone = "olive" | "terracotta" | "rust" | "neutral";

interface BadgeProps {
  children: React.ReactNode;
  tone?: BadgeTone;
  icon?: string;
  size?: "sm" | "md";
  className?: string;
}

export const Badge: React.FC<BadgeProps> = ({
  children,
  tone = "terracotta",
  icon,
  size = "sm",
  className = "",
}) => {
  const toneClasses = {
    // Olive Green: Active / Healthy / Resolved / Verified
    olive: "bg-[#F2F7EC] text-[#365314] border-[#84CC16]",
    // Terracotta: Default / In-Progress / Open / Draft / Dispatched
    terracotta: "bg-[#FEF3C7] text-[#92400E] border-[#F59E0B]",
    // Rust-Red: Urgent / Attention Needed / SOS / Critical
    rust: "bg-[#FEF2F2] text-[#991B1B] border-[#EF4444]",
    // Neutral: Muted / Archival
    neutral: "bg-surface-container text-on-surface-variant border-outline-variant",
  };

  const sizeClasses = {
    sm: "px-1.5 py-0.5 text-[10px] tracking-wider",
    md: "px-2 py-1 text-xs tracking-wider",
  };

  return (
    <span
      className={`inline-flex items-center gap-1 font-semibold uppercase rounded-full border font-body select-none ${sizeClasses[size]} ${toneClasses[tone]} ${className}`}
    >
      {icon && (
        <span className="material-symbols-outlined text-[13px] leading-none">
          {icon}
        </span>
      )}
      <span>{children}</span>
    </span>
  );
};
