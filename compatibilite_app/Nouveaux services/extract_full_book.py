import PyPDF2
import sys

# Force UTF-8 output
sys.stdout.reconfigure(encoding='utf-8')

def extract_full_book(filename, output_file):
    with open(filename, 'rb') as f:
        reader = PyPDF2.PdfReader(f)
        total_pages = len(reader.pages)
        print(f'Extracting {filename}...')
        print(f'Total pages: {total_pages}')
        
        with open(output_file, 'w', encoding='utf-8') as out:
            out.write(f'=== {filename} ===\n')
            out.write(f'Total pages: {total_pages}\n\n')
            
            for i in range(total_pages):
                page_text = reader.pages[i].extract_text()
                out.write(f'--- Page {i+1} ---\n')
                out.write(page_text if page_text else '[Page vide ou image]')
                out.write('\n\n')
                
                # Progress update every 20 pages
                if (i + 1) % 20 == 0:
                    print(f'  Progress: {i+1}/{total_pages} pages...')
        
        print(f'Done! Saved to {output_file}')

# Extract the full book
extract_full_book(
    'Self Mastery and Fate With the Cycles of Life - H. Spencer Lewis.pdf',
    'book_full_content.txt'
)
print('Extraction complete!')
