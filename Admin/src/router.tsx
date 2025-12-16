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
        ],
      },
      { path: '*', element: <Navigate to="/" replace /> },
    ],
  },
]);

export default function AppRouter() {
  return <RouterProvider router={router} />;
}
