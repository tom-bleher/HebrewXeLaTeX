# Lab Report Template

A Hebrew-English bilingual LaTeX document for scientific laboratory reports for Ubuntu Linux using XeLaTeX and Tex Live.

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

## Screenshots

### Report Screenshots
![Page 11](report/screenshots/page-11.png)

![Page 13](report/screenshots/page-13.png)

![Page 14](report/screenshots/page-14.png)

![Page 15](report/screenshots/page-15.png)

### Presentation Screenshots
![Slide 1](presentation/screenshots/slide-01.png)

![Slide 2](presentation/screenshots/slide-02.png)

![Slide 4](presentation/screenshots/slide-04.png)

![Slide 5](presentation/screenshots/slide-05.png)

## Requirements

- Compiler: XeLaTeX (required for Hebrew support)
- Bibliography: Biber backend
- Fonts: 
  - David CLM (Hebrew)
  - FreeSerif (Latin/English)
  - DejaVu Sans family

## TODO
- Fix issue with refrences between sections
