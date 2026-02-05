import { createBrowserRouter, RouterProvider, Navigate } from 'react-router-dom';
import Layout from './components/Layout';
import Dashboard from './pages/Dashboard';
import Payments from './pages/Payments';
import Users from './pages/Users';
import Settings from './pages/Settings';
import UnifiedPricing from './pages/UnifiedPricing';
import Subscriptions from './pages/Subscriptions';
import ReportsConfig from './pages/ReportsConfig';
import AdminUsers from './pages/AdminUsers';
import LegalIndex from './pages/legal';
import CompatibiliteIndex from './pages/compatibilite';
import Interpretations from './pages/compatibilite/Interpretations';
import Pricing from './pages/compatibilite/Pricing';
import Promos from './pages/compatibilite/Promos';
import Sessions from './pages/compatibilite/Sessions';
import ContentBricks from './pages/compatibilite/ContentBricks';
import CanonicalPredictions from './pages/compatibilite/CanonicalPredictions';
import TemporalPurchases from './pages/compatibilite/TemporalPurchases';
import ReportSections from './pages/compatibilite/ReportSections';
import TextTypeSettings from './pages/compatibilite/TextTypeSettings';
import Prospects from './pages/compatibilite/Prospects';
import ServiceCatalogEditor from './pages/ServiceCatalogEditor';

// Cycles de Vie imports
import CyclesIndex from './pages/cycles';
import SoulPeriods from './pages/cycles/SoulPeriods';
import DailyPeriods from './pages/cycles/DailyPeriods';
import DecisionTypes from './pages/cycles/DecisionTypes';
import DecisionAdvice from './pages/cycles/DecisionAdvice';
import CyclesPurchases from './pages/cycles/CyclesPurchases';
import CyclesPricing from './pages/cycles/CyclesPricing';
import CreditPacks from './pages/cycles/CreditPacks';
import UserCredits from './pages/cycles/UserCredits';

const router = createBrowserRouter([
  {
    path: '/',
    element: <Layout />,
    children: [
      { index: true, element: <Dashboard /> },
      { path: 'payments', element: <Payments /> },
      { path: 'users', element: <Users /> },
      { path: 'settings', element: <Settings /> },
      { path: 'pricing', element: <UnifiedPricing /> },
      { path: 'subscriptions', element: <Subscriptions /> },
      { path: 'reports', element: <ReportsConfig /> },
      { path: 'admin-users', element: <AdminUsers /> },
      { path: 'service-catalog', element: <ServiceCatalogEditor /> },
      { path: 'legal', element: <LegalIndex /> },
      {
        path: 'compatibilite',
        children: [
          { index: true, element: <CompatibiliteIndex /> },
          { path: 'interpretations', element: <Interpretations /> },
          { path: 'pricing', element: <Pricing /> },
          { path: 'promos', element: <Promos /> },
          { path: 'sessions', element: <Sessions /> },
          { path: 'content-bricks', element: <ContentBricks /> },
          { path: 'canonical-predictions', element: <CanonicalPredictions /> },
          { path: 'temporal-purchases', element: <TemporalPurchases /> },
          { path: 'report-sections', element: <ReportSections /> },
          { path: 'text-type-settings', element: <TextTypeSettings /> },
          { path: 'prospects', element: <Prospects /> },
        ],
      },
      {
        path: 'cycles',
        element: <CyclesIndex />,
        children: [
          { index: true, element: <Navigate to="soul-periods" replace /> },
          { path: 'soul-periods', element: <SoulPeriods /> },
          { path: 'daily-periods', element: <DailyPeriods /> },
          { path: 'decision-types', element: <DecisionTypes /> },
          { path: 'decision-advice', element: <DecisionAdvice /> },
          { path: 'purchases', element: <CyclesPurchases /> },
          { path: 'pricing', element: <CyclesPricing /> },
          { path: 'credit-packs', element: <CreditPacks /> },
          { path: 'user-credits', element: <UserCredits /> },
        ],
      },
      { path: '*', element: <Navigate to="/" replace /> },
    ],
  },
]);

export default function AppRouter() {
  return <RouterProvider router={router} />;
}

