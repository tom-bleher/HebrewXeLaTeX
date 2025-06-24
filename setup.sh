#!/bin/bash

# Setup script for XeLaTeX Hebrew/English Scientific Document
# This script installs all requirements for compiling with:
# /usr/bin/xelatex -shell-escape -synctex=1 -interaction=nonstopmode -file-line-error main.tex

set -e  # Exit on any error

echo "🚀 Setting up LaTeX environment for Hebrew/English scientific document..."

# Update package lists
echo "📦 Updating package lists..."
sudo apt update

# Install TeX Live full distribution (includes XeLaTeX)
echo "📚 Installing TeX Live full distribution..."
sudo apt install -y texlive-full

# Install additional TeX Live packages that might not be in the full distribution
echo "🔧 Installing additional TeX Live packages..."
sudo apt install -y \
    texlive-xetex \
    texlive-luatex \
    texlive-lang-other \
    texlive-lang-arabic \
    texlive-bibtex-extra \
    biber

# Install required fonts
echo "🔤 Installing required fonts..."

# Install Hebrew fonts (David CLM and others)
sudo apt install -y \
    fonts-sil-ezra \
    fonts-opensymbol \
    fonts-dejavu \
    fonts-liberation \
    fonts-freefont-ttf

# Install David CLM Hebrew font specifically
echo "📝 Installing David CLM Hebrew font..."
cd /tmp
wget -q https://culmus.sourceforge.io/download/culmus-0.133.tar.gz
tar -xzf culmus-0.133.tar.gz
sudo mkdir -p /usr/share/fonts/truetype/culmus
sudo cp culmus-0.133/*.ttf /usr/share/fonts/truetype/culmus/
sudo fc-cache -fv

# Install FreeSerif font (primary font for the document)
echo "🔤 Installing FreeSerif font..."
sudo apt install -y fonts-freefont-ttf

# Install additional font packages
sudo apt install -y \
    fonts-lmodern \
    fonts-texgyre \
    fonts-noto

# Install required system packages for LaTeX compilation
echo "🛠️  Installing system dependencies..."
sudo apt install -y \
    ghostscript \
    imagemagick \
    inkscape \
    python3-pygments \
    librsvg2-bin

# Install Perl modules needed by some LaTeX packages
echo "🐪 Installing Perl dependencies..."
sudo apt install -y \
    libfile-homedir-perl \
    libyaml-tiny-perl \
    liblog-log4perl-perl

# Update font cache
echo "🔄 Updating font cache..."
sudo fc-cache -fv

# Update TeX Live package manager
echo "📋 Updating TeX Live Manager..."
sudo tlmgr update --self --all 2>/dev/null || echo "⚠️  tlmgr update failed (this is often normal on Ubuntu)"

# Create a test script to verify installation
echo "🧪 Creating test compilation script..."
cat > test_compile.sh << 'EOF'
#!/bin/bash
echo "Testing LaTeX compilation..."
/usr/bin/xelatex -shell-escape -synctex=1 -interaction=nonstopmode -file-line-error main.tex
if [ $? -eq 0 ]; then
    echo "✅ First pass completed successfully"
    # Run biber for bibliography processing
    biber main 2>/dev/null || echo "ℹ️  No bibliography to process"
    # Second pass for cross-references
    /usr/bin/xelatex -shell-escape -synctex=1 -interaction=nonstopmode -file-line-error main.tex
    if [ $? -eq 0 ]; then
        echo "✅ Document compiled successfully!"
        echo "📄 Output: main.pdf"
    else
        echo "❌ Second pass failed"
        exit 1
    fi
else
    echo "❌ First pass failed"
    exit 1
fi
EOF

chmod +x test_compile.sh

# Display font verification
echo "🔍 Verifying installed fonts..."
echo "Available Hebrew fonts:"
fc-list :lang=he family | head -10

echo "Available serif fonts:"
fc-list :family=serif | grep -E "(FreeSerif|DejaVu|David)" || echo "Some fonts may not be detected yet"

# Final verification
echo "🔧 Verifying XeLaTeX installation..."
which xelatex && echo "✅ XeLaTeX found at: $(which xelatex)"
which biber && echo "✅ Biber found at: $(which biber)"

echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "📋 Your system now has:"
echo "   • XeLaTeX with full TeX Live distribution"
echo "   • Hebrew support with David CLM font"
echo "   • All required LaTeX packages"
echo "   • Bibliography processing with Biber"
echo "   • Graphics and plotting support"
echo ""
echo "🚀 To compile your document, run:"
echo "   ./test_compile.sh"
echo "   or"  
echo "   /usr/bin/xelatex -shell-escape -synctex=1 -interaction=nonstopmode -file-line-error main.tex"
echo ""
echo "💡 Note: The first compilation may take longer as fonts and packages are cached." 