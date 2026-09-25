import React from "react";
import { Routes, Route, Navigate } from "react-router-dom";
import { AppProvider } from "./context/AppContext";
import { Layout } from "./components/layout/Layout";
import { LoginScreen } from "./screens/LoginScreen";
import { DashboardScreen } from "./screens/DashboardScreen";
import { HierarchyScreen } from "./screens/HierarchyScreen";
import { DirectoryScreen } from "./screens/DirectoryScreen";
import { SOSScreen } from "./screens/SOSScreen";
import { BulkRequestsScreen } from "./screens/BulkRequestsScreen";
import { RateCardsScreen } from "./screens/RateCardsScreen";
import { DemandForecastScreen } from "./screens/DemandForecastScreen";
import { AuditLogScreen } from "./screens/AuditLogScreen";
import { AdminProfileScreen } from "./screens/AdminProfileScreen";

export const App: React.FC = () => {
  return (
    <AppProvider>
      <Routes>
        {/* Public Login with 4-Tier Fast-Track Demo Picker */}
        <Route path="/login" element={<LoginScreen />} />

        {/* Protected Cooperative Console Shell */}
        <Route path="/" element={<Layout />}>
          <Route index element={<DashboardScreen />} />
          <Route path="hierarchy" element={<HierarchyScreen />} />
          <Route path="directory" element={<DirectoryScreen />} />
          <Route path="sos" element={<SOSScreen />} />
          <Route path="bulk-requests" element={<BulkRequestsScreen />} />
          <Route path="rate-cards" element={<RateCardsScreen />} />
          <Route path="forecast" element={<DemandForecastScreen />} />
          <Route path="audit-log" element={<AuditLogScreen />} />
          <Route path="profile" element={<AdminProfileScreen />} />
        </Route>

        {/* Fallback */}
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </AppProvider>
  );
};

export default App;