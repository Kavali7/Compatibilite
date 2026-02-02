import { Outlet, useNavigate } from 'react-router-dom';
import { useState } from 'react';
import Sidebar from './Sidebar';
import Header from './Header';
import LoginScreen from './LoginScreen';
import { useAuth, AuthProvider } from '../hooks/useAuth';
import { ProjetProvider } from '../hooks/useProjet';

function LayoutContent() {
    const { isAuthenticated } = useAuth();
    const [sidebarCollapsed, setSidebarCollapsed] = useState(false);
    const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

    if (!isAuthenticated) {
        return <LoginScreen />;
    }

    return (
        <div className="layout">
            {/* Mobile menu toggle */}
            <button
                className="mobile-menu-toggle"
                onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
                aria-label="Toggle menu"
            >
                {mobileMenuOpen ? '✕' : '☰'}
            </button>

            {/* Overlay for mobile */}
            <div
                className={`sidebar-overlay ${mobileMenuOpen ? 'visible' : ''}`}
                onClick={() => setMobileMenuOpen(false)}
            />

            <Sidebar
                collapsed={sidebarCollapsed}
                onToggle={() => setSidebarCollapsed(!sidebarCollapsed)}
                mobileOpen={mobileMenuOpen}
                onMobileClose={() => setMobileMenuOpen(false)}
            />
            <div className="layout-main">
                <Header />
                <main className="layout-content">
                    <Outlet />
                </main>
            </div>
        </div>
    );
}

export default function Layout() {
    return (
        <AuthProvider>
            <ProjetProvider>
                <LayoutContent />
            </ProjetProvider>
        </AuthProvider>
    );
}
