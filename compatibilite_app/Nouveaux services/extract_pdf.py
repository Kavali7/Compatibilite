import PyPDF2
import sys

# Force UTF-8 output
sys.stdout.reconfigure(encoding='utf-8')

def extract_pdf_pages(filename, pages_to_extract=None):
    with open(filename, 'rb') as f:
        reader = PyPDF2.PdfReader(f)
        print(f'=== {filename} ===')
        print(f'Nombre total de pages: {len(reader.pages)}')
        print('')
        
        if pages_to_extract is None:
            pages_to_extract = range(len(reader.pages))
        
        for i in pages_to_extract:
            if i < len(reader.pages):
                page_text = reader.pages[i].extract_text()
                print(f'--- Page {i+1} ---')
                print(page_text if page_text else '[Page vide ou image]')
                print('')

# Extraire les pages clés du livre (table des matières, intro, chapitres principaux)
print('=' * 80)
print('LIVRE: Self Mastery and Fate With the Cycles of Life')
print('=' * 80)
# Pages: Table des matières, intro, et chapitres sur les cycles
# On va extraire les 30 premières pages pour avoir la structure et concepts de base
extract_pdf_pages('Self Mastery and Fate With the Cycles of Life - H. Spencer Lewis.pdf', range(0, 35))
print('=' * 80)
