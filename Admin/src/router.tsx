import { createBrowserRouter, Outlet } from 'react-router-dom';
import Layout from './components/Layout';
import Dashboard from './pages/Dashboard';
import Users from './pages/Users';
import Payments from './pages/Payments';
import Settings from './pages/Settings';

// Compatibilité pages
import CompatibiliteIndex from './pages/compatibilite/index';
import Interpretations from './pages/compatibilite/Interpretations';
import ContentBricks from './pages/compatibilite/ContentBricks';
import CanonicalPredictions from './pages/compatibilite/CanonicalPredictions';
import CompatibilitePricing from './pages/compatibilite/Pricing';
import Promos from './pages/compatibilite/Promos';
import ReportSections from './pages/compatibilite/ReportSections';
import Prospects from './pages/compatibilite/Prospects';
import Sessions from './pages/compatibilite/Sessions';
import TextTypeSettings from './pages/compatibilite/TextTypeSettings';
import TemporalPurchases from './pages/compatibilite/TemporalPurchases';
import SocialProofEditor from './pages/SocialProofEditor';

// Cycles de Vie pages
import CyclesIndex from './pages/cycles/index';
import SoulPeriods from './pages/cycles/SoulPeriods';
import DailyPeriods from './pages/cycles/DailyPeriods';
import DecisionTypes from './pages/cycles/DecisionTypes';
import DecisionAdvice from './pages/cycles/DecisionAdvice';
import CyclesPurchases from './pages/cycles/CyclesPurchases';
import CyclesPricing from './pages/cycles/CyclesPricing';
import CreditPacks from './pages/cycles/CreditPacks';
import UserCredits from './pages/cycles/UserCredits';

// New content pages
import PersonalCyclePeriods from './pages/cycles/PersonalCyclePeriods';
import BusinessCyclePeriods from './pages/cycles/BusinessCyclePeriods';
import HealthCyclePeriods from './pages/cycles/HealthCyclePeriods';
import LifePhases from './pages/cycles/LifePhases';
import LunarPhases from './pages/cycles/LunarPhases';

import { RouterProvider } from 'react-router-dom';

const router = createBrowserRouter([
  {
    path: '/',
    element: <Layout />,
    children: [
      { index: true, element: <Dashboard /> },
      { path: 'users', element: <Users /> },
      { path: 'payments', element: <Payments /> },
      { path: 'settings', element: <Settings /> },
      { path: 'compatibility-text-settings', element: <TextTypeSettings /> },

      // Compatibilité group
      {
        path: 'compatibilite',
        element: <Outlet />,
        children: [
          { index: true, element: <CompatibiliteIndex /> },
          { path: 'interpretations', element: <Interpretations /> },
          { path: 'content-bricks', element: <ContentBricks /> },
          { path: 'canonical-predictions', element: <CanonicalPredictions /> },
          { path: 'pricing', element: <CompatibilitePricing /> },
          { path: 'promos', element: <Promos /> },
          { path: 'promo-codes', element: <Promos /> },
          { path: 'report-sections', element: <ReportSections /> },
          { path: 'prospects', element: <Prospects /> },
          { path: 'sessions', element: <Sessions /> },
          { path: 'text-type-settings', element: <TextTypeSettings /> },
          { path: 'temporal-purchases', element: <TemporalPurchases /> },
          { path: 'social-proof', element: <SocialProofEditor /> },
          { path: 'legal', element: <div className="page-placeholder"><h2>📃 Pages Légales</h2><p>En cours de développement...</p></div> },
        ],
      },

      // Cycles de Vie group
      {
        path: 'cycles',
        element: <CyclesIndex />,
        children: [
          { path: 'soul-periods', element: <SoulPeriods /> },
          { path: 'daily-periods', element: <DailyPeriods /> },
          { path: 'decision-types', element: <DecisionTypes /> },
          { path: 'decision-advice', element: <DecisionAdvice /> },
          { path: 'purchases', element: <CyclesPurchases /> },
          { path: 'pricing', element: <CyclesPricing /> },
          { path: 'credit-packs', element: <CreditPacks /> },
          { path: 'user-credits', element: <UserCredits /> },

          // New content pages
          { path: 'personal-cycle', element: <PersonalCyclePeriods /> },
          { path: 'business-cycle', element: <BusinessCyclePeriods /> },
          { path: 'health-cycle', element: <HealthCyclePeriods /> },
          { path: 'life-phases', element: <LifePhases /> },
          { path: 'lunar-phases', element: <LunarPhases /> },
        ],
      },
    ],
  },
]);

export default function AppRouter() {
  return <RouterProvider router={router} />;
}
