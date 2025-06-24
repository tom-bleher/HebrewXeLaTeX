# Lab Report Template

A Hebrew-English bilingual LaTeX document for scientific laboratory reports.

## Project Structure

```
LabTemplate
├── main.tex              # Main document file
├── template.tex          # LaTeX template with Hebrew/English support
├── bibliography.bib      # Bibliography database
├── compile.sh           # Compilation script
├── setup.sh            # Environment setup script
├── sectionsA/          # First experimental section
│   ├── OpeningPageA.tex    # Title page and student info
│   ├── why.tex            # Purpose of experiment
│   ├── theory.tex         # Theoretical background
│   ├── items.tex          # Equipment list
│   ├── expProcess.tex     # Experimental procedure
│   ├── ibud_plan.tex      # Data processing plan
│   ├── ibud.tex           # Results processing
│   ├── diun.tex           # Discussion
│   ├── nispah.tex         # Appendix
│   └── media/             # Images and figures
└── sectionsB/          # Second experimental section
    └── [same structure as sectionsA]
```

## Quick Start

### 1. Setup Environment
Run the setup script to install all required dependencies:
```bash
chmod +x setup.sh
./setup.sh
```

This will install:
- TeX Live full distribution with XeLaTeX
- Hebrew font support (David CLM)
- Bibliography processor (Biber)
- All required LaTeX packages

### 2. Compile Document
Use the provided compilation script:
```bash
chmod +x compile.sh
./compile.sh
```

## Document Features

- Bilingual Support: Hebrew (primary) and English
- Bibliography: Automatic citation processing with Biber

## Requirements

- Compiler: XeLaTeX (required for Hebrew support)
- Bibliography: Biber backend
- Fonts: 
  - David CLM (Hebrew)
  - FreeSerif (Latin/English)
  - DejaVu Sans family

## TODO
- Fix issue with refrences between sections