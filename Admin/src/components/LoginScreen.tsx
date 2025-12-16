import { useState } from 'react';
import { useAuth } from '../hooks/useAuth';

export default function LoginScreen() {
    const { login } = useAuth();
    const [password, setPassword] = useState('');
    const [error, setError] = useState('');

    const handleSubmit = (e: React.FormEvent) => {
        e.preventDefault();
        setError('');
        if (!login(password)) {
            setError('Mot de passe incorrect');
        }
    };

    return (
        <div className="login-screen">
            <div className="login-card">
                <div className="login-icon">🔷</div>
                <h1 className="login-title">Growpeak Admin</h1>
                <p className="login-subtitle">Panneau d'administration</p>

                <form onSubmit={handleSubmit} className="login-form">
                    <input
                        type="password"
                        placeholder="Mot de passe admin"
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                        className="login-input"
                        autoFocus
                    />
                    {error && <div className="login-error">{error}</div>}
                    <button type="submit" className="login-button">
                        Se connecter
                    </button>
                </form>
            </div>
        </div>
    );
}
