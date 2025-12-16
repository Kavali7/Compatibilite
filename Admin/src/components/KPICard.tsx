type KPICardProps = {
    icon: string;
    label: string;
    value: string | number;
    trend?: string;
    trendUp?: boolean;
};

export default function KPICard({ icon, label, value, trend, trendUp }: KPICardProps) {
    return (
        <div className="kpi-card">
            <div className="kpi-icon">{icon}</div>
            <div className="kpi-content">
                <div className="kpi-value">{value}</div>
                <div className="kpi-label">{label}</div>
                {trend && (
                    <div className={`kpi-trend ${trendUp ? 'up' : 'down'}`}>
                        {trendUp ? '↑' : '↓'} {trend}
                    </div>
                )}
            </div>
        </div>
    );
}
