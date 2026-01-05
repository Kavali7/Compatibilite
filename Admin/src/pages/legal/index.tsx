import { useState, useEffect } from 'react';
import { supabase } from '../../supabaseClient';

type LegalPage = {
    id: string;
    slug: string;
    title: string;
    content: string;
    is_active: boolean;
    display_order: number;
};

export default function LegalIndex() {
    const [pages, setPages] = useState<LegalPage[]>([]);
    const [loading, setLoading] = useState(true);
    const [selectedPage, setSelectedPage] = useState<LegalPage | null>(null);
    const [isEditing, setIsEditing] = useState(false);

    // Form state
    const [editForm, setEditForm] = useState<Partial<LegalPage>>({});
    const [saveMessage, setSaveMessage] = useState<{ type: 'success' | 'error', text: string } | null>(null);

    useEffect(() => {
        fetchPages();
    }, []);

    async function fetchPages() {
        try {
            setLoading(true);
            const { data, error } = await supabase
                .from('legal_pages')
                .select('*')
                .order('display_order', { ascending: true });

            if (error) throw error;
            setPages(data || []);
        } catch (error) {
            console.error('Error fetching legal pages:', error);
        } finally {
            setLoading(false);
        }
    }

    function handleEdit(page: LegalPage) {
        setSelectedPage(page);
        setEditForm(page);
        setIsEditing(true);
        setSaveMessage(null);
    }

    function handleCreate() {
        const newPage = {
            title: 'Nouvelle Page',
            slug: 'nouvelle-page',
            content: '# Titre\n\nContenu ici...',
            is_active: false,
            display_order: pages.length * 10 + 10
        };
        setSelectedPage(null); // It's a new page
        setEditForm(newPage);
        setIsEditing(true);
        setSaveMessage(null);
    }

    async function handleSave() {
        setSaveMessage(null);
        try {
            if (!editForm.slug || !editForm.title) {
                setSaveMessage({ type: 'error', text: 'Titre et Identifiant (slug) requis.' });
                return;
            }

            const pageData = {
                slug: editForm.slug,
                title: editForm.title,
                content: editForm.content,
                is_active: editForm.is_active,
                display_order: editForm.display_order
            };

            let error;
            if (selectedPage?.id) {
                // Update
                const result = await supabase
                    .from('legal_pages')
                    .update(pageData)
                    .eq('id', selectedPage.id);
                error = result.error;
            } else {
                // Insert
                const result = await supabase
                    .from('legal_pages')
                    .insert([pageData]);
                error = result.error;
            }

            if (error) throw error;

            setSaveMessage({ type: 'success', text: 'Page enregistrée avec succès !' });
            await fetchPages();

            // If it was an insert, switch to edit mode for the new item or just close
            if (!selectedPage?.id) setIsEditing(false);

        } catch (err: any) {
            console.error('Error saving:', err);
            setSaveMessage({ type: 'error', text: 'Erreur: ' + err.message });
        }
    }

    async function handleDelete(id: string) {
        if (!window.confirm('Êtes-vous sûr de vouloir supprimer cette page ?')) return;

        try {
            const { error } = await supabase.from('legal_pages').delete().eq('id', id);
            if (error) throw error;
            fetchPages();
            if (selectedPage?.id === id) {
                setIsEditing(false);
                setSelectedPage(null);
            }
        } catch (err) {
            console.error(err);
            alert('Erreur lors de la suppression');
        }
    }

    if (loading) return <div className="p-8 text-center">Chargement...</div>;

    if (isEditing) {
        return (
            <div className="p-6 bg-white rounded-lg shadow">
                <div className="flex justify-between items-center mb-6">
                    <button
                        onClick={() => setIsEditing(false)}
                        className="text-gray-600 hover:text-gray-900 font-medium"
                    >
                        ← Retour à la liste
                    </button>
                    <h2 className="text-2xl font-bold">
                        {selectedPage ? 'Modifier la page' : 'Créer une page'}
                    </h2>
                </div>

                {saveMessage && (
                    <div className={`p-4 mb-4 rounded ${saveMessage.type === 'success' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}`}>
                        {saveMessage.text}
                    </div>
                )}

                <div className="space-y-4">
                    <div className="grid grid-cols-2 gap-4">
                        <div>
                            <label htmlFor="title" className="block text-sm font-medium text-gray-700">Titre</label>
                            <input
                                id="title"
                                type="text"
                                value={editForm.title || ''}
                                onChange={e => setEditForm({ ...editForm, title: e.target.value })}
                                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 border p-2"
                            />
                        </div>
                        <div>
                            <label htmlFor="slug" className="block text-sm font-medium text-gray-700">Identifiant URL (slug)</label>
                            <input
                                id="slug"
                                type="text"
                                value={editForm.slug || ''}
                                onChange={e => setEditForm({ ...editForm, slug: e.target.value })}
                                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 border p-2"
                            />
                        </div>
                    </div>

                    <div className="grid grid-cols-3 gap-4">
                        <div>
                            <label htmlFor="order" className="block text-sm font-medium text-gray-700">Ordre</label>
                            <input
                                id="order"
                                type="number"
                                value={editForm.display_order || 0}
                                onChange={e => setEditForm({ ...editForm, display_order: parseInt(e.target.value) })}
                                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 border p-2"
                            />
                        </div>
                        <div className="flex items-end pb-3">
                            <label className="inline-flex items-center cursor-pointer">
                                <input
                                    type="checkbox"
                                    checked={editForm.is_active || false}
                                    onChange={e => setEditForm({ ...editForm, is_active: e.target.checked })}
                                    className="form-checkbox h-5 w-5 text-indigo-600"
                                    aria-label="Page Active"
                                />
                                <span className="ml-2 text-gray-700 font-medium">Page Active (Visible)</span>
                            </label>
                        </div>
                    </div>

                    <div>
                        <label htmlFor="content" className="block text-sm font-medium text-gray-700 mb-1">Contenu (Markdown)</label>
                        <p className="text-xs text-gray-500 mb-2">Utilisez # pour les titres, **gras** pour le gras, - pour les listes.</p>
                        <textarea
                            id="content"
                            value={editForm.content || ''}
                            onChange={e => setEditForm({ ...editForm, content: e.target.value })}
                            rows={15}
                            className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 border p-2 font-mono text-sm"
                        />
                    </div>

                    <div className="flex justify-end pt-4">
                        <button
                            onClick={handleSave}
                            className="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2 px-6 rounded"
                        >
                            Enregistrer
                        </button>
                    </div>
                </div>
            </div>
        );
    }

    return (
        <div className="p-6">
            <div className="flex justify-between items-center mb-6">
                <div>
                    <h2 className="text-2xl font-bold text-gray-900">Pages Légales Dynamiques</h2>
                    <p className="text-sm text-gray-500">Gérez le contenu légal affiché sur l'application mobile et le site.</p>
                </div>
                <button
                    onClick={handleCreate}
                    className="bg-green-600 hover:bg-green-700 text-white font-bold py-2 px-4 rounded flex items-center"
                >
                    + Nouvelle Page
                </button>
            </div>

            <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
                {pages.map((page) => (
                    <div
                        key={page.id}
                        className={`relative rounded-lg border bg-white px-6 py-5 shadow-sm flex flex-col justify-between hover:border-gray-400 focus-within:ring-2 focus-within:ring-indigo-500 focus-within:ring-offset-2 ${!page.is_active ? 'opacity-60 border-dashed' : ''}`}
                    >
                        <div className="mb-4">
                            <div className="flex justify-between items-start">
                                <h3 className="text-lg font-medium text-gray-900">
                                    {page.title}
                                </h3>
                                <span className={`inline-flex items-center px-2 py-0.5 rounded text-xs font-medium ${page.is_active ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'}`}>
                                    {page.is_active ? 'Active' : 'Brouillon'}
                                </span>
                            </div>
                            <p className="text-xs text-gray-500 mt-1">/{page.slug} • Ordre: {page.display_order}</p>
                            <p className="mt-2 text-sm text-gray-600 line-clamp-3">
                                {page.content.substring(0, 150)}...
                            </p>
                        </div>
                        <div className="flex justify-end space-x-2 mt-auto border-t pt-2">
                            <button
                                onClick={() => handleDelete(page.id)}
                                className="text-red-600 hover:text-red-900 text-sm font-medium px-2 py-1"
                            >
                                Supprimer
                            </button>
                            <button
                                onClick={() => handleEdit(page)}
                                className="bg-indigo-50 text-indigo-700 hover:bg-indigo-100 text-sm font-medium px-3 py-1 rounded"
                            >
                                Modifier
                            </button>
                        </div>
                    </div>
                ))}
            </div>

            {pages.length === 0 && (
                <div className="text-center py-12 bg-gray-50 rounded-lg border-2 border-dashed border-gray-300">
                    <p className="text-gray-500">Aucune page légale trouvée.</p>
                    <button onClick={fetchPages} className="text-indigo-600 underline mt-2">Réessayer</button>
                </div>
            )}
        </div>
    );
}
