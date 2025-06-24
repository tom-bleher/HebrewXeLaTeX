#!/bin/bash

# Compile script for Hebrew/English LaTeX document
# Compiles main.tex using XeLaTeX with proper bibliography processing

set -e  # Exit on any error

echo "🔧 Compiling LaTeX document..."

# Clean up previous compilation files (optional)
echo "🧹 Cleaning up previous compilation files..."
rm -f main.aux main.bbl main.bcf main.blg main.fdb_latexmk main.fls main.log main.out main.run.xml main.synctex.gz main.toc main.lof main.lot

# First pass - XeLaTeX compilation
echo "📝 Running first XeLaTeX pass..."
/usr/bin/xelatex -shell-escape -synctex=1 -interaction=nonstopmode -file-line-error main.tex

if [ $? -ne 0 ]; then
    echo "❌ First XeLaTeX pass failed!"
    echo "📋 Check the compilation errors above."
    exit 1
fi

echo "✅ First pass completed successfully"

# Check if bibliography file exists and has content
if [ -f "bibliography.bib" ] && [ -s "bibliography.bib" ]; then
    echo "📚 Processing bibliography with Biber..."
    biber main
    
    if [ $? -ne 0 ]; then
        echo "⚠️  Biber processing had issues, but continuing..."
    else
        echo "✅ Bibliography processed successfully"
    fi
else
    echo "ℹ️  No bibliography to process (bibliography.bib is empty or missing)"
fi

# Second pass - resolve bibliography citations and cross-references
echo "📝 Running second XeLaTeX pass (for cross-references and bibliography)..."
/usr/bin/xelatex -shell-escape -synctex=1 -interaction=nonstopmode -file-line-error main.tex

if [ $? -ne 0 ]; then
    echo "❌ Second XeLaTeX pass failed!"
    echo "📋 Check the compilation errors above."
    exit 1
fi

echo "✅ Second pass completed successfully"

# Third pass - final resolution (recommended for complex documents)
echo "📝 Running third XeLaTeX pass (final resolution)..."
/usr/bin/xelatex -shell-escape -synctex=1 -interaction=nonstopmode -file-line-error main.tex

if [ $? -ne 0 ]; then
    echo "❌ Third XeLaTeX pass failed!"
    echo "📋 Check the compilation errors above."
    exit 1
fi

echo "✅ Third pass completed successfully"

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