import React from "react";

export type ButtonVariant = "primary" | "secondary" | "inverted" | "outlined";
export type ButtonSize = "sm" | "md" | "lg";

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: ButtonVariant;
  size?: ButtonSize;
  icon?: string; // Material symbol or text icon
  children: React.ReactNode;
}

export const Button: React.FC<ButtonProps> = ({
  variant = "primary",
  size = "md",
  icon,
  children,
  className = "",
  disabled,
  ...props
}) => {
  const baseClasses =
    "inline-flex items-center justify-center font-bold font-body transition-all duration-150 rounded-xl cursor-pointer select-none focus:outline-none disabled:opacity-50 disabled:cursor-not-allowed active:scale-[0.98]";

  const sizeClasses = {
    sm: "px-2.5 py-1 text-xs gap-1.5 h-8",
    md: "px-3.5 py-1.5 text-xs tracking-wider uppercase gap-2 h-9",
    lg: "px-5 py-2.5 text-sm tracking-wider uppercase gap-2.5 h-11",
  };

  const variantClasses = {
    // Primary: Terracotta
    primary:
      "bg-primary-container text-white border border-[#92400E] hover:bg-[#92400E] shadow-sm",
    // Secondary: Rust Red (Urgent / SOS)
    secondary:
      "bg-[#C2410C] text-white border border-[#9A3412] hover:bg-[#9A3412] shadow-sm",
    // Inverted: Dark Charcoal / Stone Black (Authoritative)
    inverted:
      "bg-[#1C1917] text-[#FAF6F0] border border-[#1C1917] hover:bg-[#292524] shadow-sm",
    // Outlined: Cream surface with hairline border
    outlined:
      "bg-transparent text-[#292524] border border-[#D6C7B2] hover:bg-[#F5EFEB] hover:border-outline",
  };

  return (
    <button
      className={`${baseClasses} ${sizeClasses[size]} ${variantClasses[variant]} ${className}`}
      disabled={disabled}
      {...props}
    >
      {icon && (
        <span className="material-symbols-outlined text-[16px] leading-none">
          {icon}
        </span>
      )}
      <span>{children}</span>
    </button>
  );
};
