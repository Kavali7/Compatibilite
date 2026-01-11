import { createBrowserRouter, RouterProvider, Navigate } from 'react-router-dom';
import Layout from './components/Layout';
import Dashboard from './pages/Dashboard';
import Payments from './pages/Payments';
import Settings from './pages/Settings';
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

const router = createBrowserRouter([
  {
    path: '/',
    element: <Layout />,
    children: [
      { index: true, element: <Dashboard /> },
      { path: 'payments', element: <Payments /> },
      { path: 'settings', element: <Settings /> },
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
      { path: '*', element: <Navigate to="/" replace /> },
    ],
  },
]);

export default function AppRouter() {
  return <RouterProvider router={router} />;
}
