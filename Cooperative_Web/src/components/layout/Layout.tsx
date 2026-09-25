import React, { useState, useEffect } from "react";
import { Outlet, useNavigate, useLocation } from "react-router-dom";
import { Topbar } from "./Topbar";
import { Sidebar } from "./Sidebar";
import { GlobalSearchModal } from "../common/GlobalSearchModal";
import { useApp } from "../../context/AppContext";

export const Layout: React.FC = () => {
  const { currentAccount } = useApp();
  const navigate = useNavigate();
  const location = useLocation();

  const [isSearchOpen, setIsSearchOpen] = useState(false);
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);

  // If not logged in, redirect to login
  useEffect(() => {
    if (!currentAccount && location.pathname !== "/login") {
      navigate("/login");
    }
  }, [currentAccount, location.pathname, navigate]);

  // Global hotkey: Ctrl+K or Cmd+K
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === "k") {
        e.preventDefault();
        setIsSearchOpen(true);
      }
    };
    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, []);

  // Close mobile drawer on route change
  useEffect(() => {
    setIsMobileMenuOpen(false);
  }, [location.pathname]);

  if (!currentAccount) {
    return null;
  }

  return (
    <div className="min-h-screen bg-surface text-on-surface flex flex-col font-body selection:bg-primary-fixed selection:text-on-primary-fixed">
      {/* Top Application Bar */}
      <Topbar
        onOpenSearch={() => setIsSearchOpen(true)}
        onToggleMobileMenu={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
      />

      {/* Main Body with Fixed Side Navigation Rail and Canvas */}
      <div className="flex-1 flex overflow-hidden">
        <Sidebar
          isOpen={isMobileMenuOpen}
          onClose={() => setIsMobileMenuOpen(false)}
        />

        {/* Scrollable Canvas */}
        <main className="flex-1 overflow-y-auto min-h-[calc(100vh-3.5rem)] bg-surface p-4 sm:p-6 lg:p-8">
          <div className="max-w-7xl mx-auto space-y-6">
            <Outlet />
          </div>
        </main>
      </div>

      {/* Global Search Dialog */}
      <GlobalSearchModal
        isOpen={isSearchOpen}
        onClose={() => setIsSearchOpen(false)}
        onNavigate={(path) => navigate(path)}
      />
    </div>
  );
};
