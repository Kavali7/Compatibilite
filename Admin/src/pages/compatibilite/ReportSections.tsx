import React, { useEffect, useState } from 'react';
import { supabase } from '../../supabaseClient';
import { ReportSection } from '../../types';

export default function ReportSections() {
    const [sections, setSections] = useState<ReportSection[]>([]);
    const [loading, setLoading] = useState(true);
    const [saving, setSaving] = useState(false);
    const [message, setMessage] = useState<{ type: 'success' | 'error', text: string } | null>(null);

    useEffect(() => {
        fetchSections();
    }, []);

    async function fetchSections() {
        try {
            setLoading(true);
            const { data, error } = await supabase
                .from('report_sections')
                .select('*')
                .order('display_order', { ascending: true });

            if (error) throw error;
            setSections(data || []);
        } catch (error) {
            console.error('Error fetching sections:', error);
            setMessage({ type: 'error', text: 'Erreur lors du chargement des sections.' });
        } finally {
            setLoading(false);
        }
    }

    async function handleSave(section: ReportSection) {
        try {
            setSaving(true);
            setMessage(null);
            const { error } = await supabase
                .from('report_sections')
                .update({ label_fr: section.label_fr, is_active: section.is_active })
                .eq('code', section.code);

            if (error) throw error;
            setMessage({ type: 'success', text: `Section "${section.code}" mise à jour !` });

            // Refresh local state to confirm (optional, could just rely on input state)
            setSections(prev => prev.map(s => s.code === section.code ? section : s));
        } catch (error) {
            console.error('Error updating section:', error);
            setMessage({ type: 'error', text: 'Erreur lors de la sauvegarde.' });
        } finally {
            setSaving(false);
        }
    }

    const handleLabelChange = (code: string, newLabel: string) => {
        setSections(prev => prev.map(s => s.code === code ? { ...s, label_fr: newLabel } : s));
    };

    const handleActiveToggle = (code: string) => {
        setSections(prev =>
            prev.map(s => {
                if (s.code === code) {
                    const updated = { ...s, is_active: !s.is_active };
                    // Auto-save on toggle can be nice, or wait for explicit save. 
                    // Let's autosave for toggle, but manual save for text to avoid spam.
                    handleSave(updated);
                    return updated;
                }
                return s;
            })
        );
    };

    if (loading) return <div className="p-8 text-center">Chargement...</div>;

    return (
        <div className="p-6">
            <div className="flex justify-between items-center mb-6">
                <h1 className="text-2xl font-bold">Gestion des Sections du Rapport</h1>
            </div>

            {message && (
                <div className={`p-4 mb-4 rounded ${message.type === 'success' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}`}>
                    {message.text}
                </div>
            )}

            <div className="bg-white rounded-lg shadow overflow-hidden">
                <table className="min-w-full divide-y divide-gray-200">
                    <thead className="bg-gray-50">
                        <tr>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Ordre</th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Code / Description</th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Titre Affiché (Label FR)</th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actif ?</th>
                            <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                        </tr>
                    </thead>
                    <tbody className="bg-white divide-y divide-gray-200">
                        {sections.map((section) => (
                            <tr key={section.code} className={!section.is_active ? 'bg-gray-50 opacity-75' : ''}>
                                <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                    {section.display_order}
                                </td>
                                <td className="px-6 py-4 whitespace-nowrap">
                                    <div className="text-sm font-medium text-gray-900">{section.code}</div>
                                    <div className="text-sm text-gray-500">{section.description}</div>
                                    <span className="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-blue-100 text-blue-800">
                                        {section.periode}
                                    </span>
                                </td>
                                <td className="px-6 py-4 whitespace-nowrap">
                                    <input
                                        type="text"
                                        value={section.label_fr}
                                        onChange={(e) => handleLabelChange(section.code, e.target.value)}
                                        className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm p-2 border"
                                    />
                                </td>
                                <td className="px-6 py-4 whitespace-nowrap">
                                    <button
                                        onClick={() => handleActiveToggle(section.code)}
                                        className={`px-3 py-1 rounded-full text-sm font-medium transition-colors ${section.is_active
                                                ? 'bg-green-100 text-green-800 hover:bg-green-200'
                                                : 'bg-red-100 text-red-800 hover:bg-red-200'
                                            }`}
                                    >
                                        {section.is_active ? '✓ Actif' : '✗ Inactif'}
                                    </button>
                                </td>
                                <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                    <button
                                        onClick={() => handleSave(section)}
                                        disabled={saving}
                                        className="text-indigo-600 hover:text-indigo-900 font-bold disabled:opacity-50"
                                    >
                                        Sauvegarder
                                    </button>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        </div>
    );
}
