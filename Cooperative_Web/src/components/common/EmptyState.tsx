import React from "react";
import { Button } from "./Button";

interface EmptyStateProps {
  icon?: string;
  title: string;
  description: string;
  actionLabel?: string;
  onAction?: () => void;
  className?: string;
}

export const EmptyState: React.FC<EmptyStateProps> = ({
  icon = "folder_open",
  title,
  description,
  actionLabel,
  onAction,
  className = "",
}) => {
  return (
    <div
      className={`flex flex-col items-center justify-center p-8 sm:p-12 text-center bg-surface-container-low border border-line-hairline rounded-DEFAULT ${className}`}
    >
      <div className="w-14 h-14 rounded-md bg-surface-container border border-outline-variant flex items-center justify-center text-primary mb-4 shadow-sm">
        <span className="material-symbols-outlined text-3xl">{icon}</span>
      </div>
      <h3 className="font-headline text-lg font-semibold text-on-surface mb-1">
        {title}
      </h3>
      <p className="font-body text-xs text-on-surface-variant max-w-sm mb-5 leading-relaxed">
        {description}
      </p>
      {actionLabel && onAction && (
        <Button variant="primary" size="sm" onClick={onAction}>
          {actionLabel}
        </Button>
      )}
    </div>
  );
};
