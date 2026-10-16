# Compilation : lancer `latexmk` à la racine du projet
@default_files = ('main.tex');
$pdf_mode = 1;              # pdflatex
$out_dir = 'build';         # PDF et fichiers auxiliaires dans build/
$pdflatex = 'pdflatex -interaction=nonstopmode -file-line-error -synctex=1 %O %S';
