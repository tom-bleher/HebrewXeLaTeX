#!/bin/bash

# Compile script for Hebrew/English LaTeX document
# Compiles main.tex using XeLaTeX with proper bibliography processing

set -e  # Exit on any error

echo "🔧 Compiling LaTeX document..."

# Create .logs directory for compilation files
echo "📁 Creating .logs directory for compilation files..."
mkdir -p .logs

# Clean up previous compilation files
echo "🧹 Cleaning up previous compilation files..."
rm -f main.aux main.bbl main.bcf main.blg main.fdb_latexmk main.fls main.log main.out main.run.xml main.synctex.gz main.toc main.lof main.lot
rm -f .logs/main.*
# Clean up minted cache folders
rm -rf _minted-main

# Function to move auxiliary files to .logs directory
move_aux_files() {
    echo "📂 Moving auxiliary files to .logs directory..."
    for file in main.aux main.bcf main.blg main.fdb_latexmk main.fls main.log main.out main.run.xml main.synctex.gz main.toc main.lof main.lot; do
        if [ -f "$file" ]; then
            mv "$file" ".logs/"
        fi
    done
}

# First pass - XeLaTeX compilation
echo "📝 Running first XeLaTeX pass..."
/usr/bin/xelatex -shell-escape -synctex=1 -interaction=nonstopmode -file-line-error main.tex

# Check if PDF was created (more important than exit code)
if [ ! -f "main.pdf" ]; then
    echo "❌ First XeLaTeX pass failed - no PDF generated!"
    echo "📋 Check the compilation errors above."
    move_aux_files
    exit 1
fi

echo "✅ First pass completed successfully"
move_aux_files

# Check if bibliography file exists and has content
if [ -f "bibliography.bib" ] && [ -s "bibliography.bib" ]; then
    echo "📚 Processing bibliography with Biber..."
    /usr/bin/biber .logs/main
    
    if [ $? -ne 0 ]; then
        echo "⚠️  Biber processing had issues, but continuing..."
    else
        echo "✅ Bibliography processed successfully"
        # Copy .bbl file back for next compilation
        if [ -f ".logs/main.bbl" ]; then
            cp ".logs/main.bbl" "main.bbl"
        fi
    fi
else
    echo "ℹ️  No bibliography to process (bibliography.bib is empty or missing)"
fi

# Second pass - resolve bibliography citations and cross-references
echo "📝 Running second XeLaTeX pass (for cross-references and bibliography)..."
/usr/bin/xelatex -shell-escape -synctex=1 -interaction=nonstopmode -file-line-error main.tex

# Check if PDF was created (more important than exit code)
if [ ! -f "main.pdf" ]; then
    echo "❌ Second XeLaTeX pass failed - no PDF generated!"
    echo "📋 Check the compilation errors above."
    move_aux_files
    exit 1
fi

echo "✅ Second pass completed successfully"
move_aux_files

# Third pass - final resolution (recommended for complex documents)
echo "📝 Running third XeLaTeX pass (final resolution)..."
/usr/bin/xelatex -shell-escape -synctex=1 -interaction=nonstopmode -file-line-error main.tex

# Check if PDF was created (more important than exit code)
if [ ! -f "main.pdf" ]; then
    echo "❌ Third XeLaTeX pass failed - no PDF generated!"
    echo "📋 Check the compilation errors above."
    move_aux_files
    exit 1
fi

echo "✅ Third pass completed successfully"

# Final cleanup - move all auxiliary files to .logs
move_aux_files

# Also move any .bbl files that were copied back
if [ -f "main.bbl" ]; then
    mv "main.bbl" ".logs/"
fi

# Clean up minted cache folders
if [ -d "_minted-main" ]; then
    rm -rf "_minted-main"
fi

# Check if PDF was generated
if [ -f "main.pdf" ]; then
    echo ""
    echo "🎉 Document compiled successfully!"
    echo "📄 Output file: main.pdf"
    echo "📊 File size: $(ls -lh main.pdf | awk '{print $5}')"
    echo ""
    
    # Optional: Open the PDF if running in a desktop environment
    if command -v xdg-open >/dev/null 2>&1; then
        read -p "📖 Open PDF in default viewer? [y/N]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            xdg-open main.pdf &
        fi
    fi
else
    echo "❌ PDF file was not generated!"
    echo "📋 Check for errors in the compilation process above."
    exit 1
fi

echo "✨ Compilation completed successfully!" 
echo "📁 All compilation files organized in .logs/ directory"