# Cahier des charges – Qribna

Cahier des charges du projet **Qribna**, rédigé en LaTeX dans le cadre du module de génie logiciel (M2SI, INSEA).

Qribna est une plateforme web qui relie les clients, les réparateurs et les propriétaires de boutiques de réparation de téléphones au Maroc : gestion des réparations, géolocalisation des boutiques, suivi par WhatsApp, paiement et statistiques du marché. L’expression des besoins de l’équipe se trouve dans [`besoins.txt`](besoins.txt).

| Version | Date | État | PDF |
|---|---|---|---|
| 2.0 | 16/10/2026 | En cours de rédaction | [`build/main.pdf`](build/main.pdf) |
| 1.0 | 16/10/2026 | Terminée (archivée) | [`archives/v1.0-2026-10-16/cahier-des-charges-v1.0.pdf`](archives/v1.0-2026-10-16/cahier-des-charges-v1.0.pdf) |

## Démarrer le projet

### 1. Prérequis

- **Une distribution LaTeX** avec `pdflatex` et `latexmk` :
  - Windows : [MiKTeX](https://miktex.org/download) ;
  - Linux : TeX Live (`sudo apt install texlive-full`, ou `texlive-latex-extra texlive-fonts-extra texlive-lang-french latexmk`) ;
  - macOS : [MacTeX](https://www.tug.org/mactex/).
- **Perl**, requis par `latexmk` (déjà présent sous Linux et macOS ; sous Windows, installer [Strawberry Perl](https://strawberryperl.com/)).
- **Git**, pour cloner le dépôt.

Paquets LaTeX utilisés : `babel` (french), `caladea`, `microtype`, `xcolor`, `etoolbox`, `tabularx`, `booktabs`, `enumitem`, `longtable`, `array`, `tikz`, `titlesec`, `titletoc`, `pdfpages`, `fancyhdr`, `lastpage`, `tcolorbox`, `hyperref`.

### 2. Cloner le dépôt

```bash
git clone https://github.com/BassirouKadade/cahier-des-charges-qribna.git
cd cahier-des-charges-qribna
```

### 3. Installer les paquets manquants (MiKTeX)

MiKTeX peut être configuré pour ne pas installer les paquets à la volée. Dans ce cas, installer ceux qui manquent avant la première compilation :

```bash
miktex packages install caladea
```

Si la compilation signale `File 'x.sty' not found`, installer le paquet correspondant de la même façon (`miktex packages install x`), puis relancer.

### 4. Compiler

À la racine du dépôt :

```bash
latexmk          # compilation (configuration dans .latexmkrc)
latexmk -g       # force une recompilation complète
latexmk -c       # supprime les fichiers auxiliaires
```

Le PDF est produit dans `build/main.pdf`. Les fichiers auxiliaires restent dans `build/`.

Sans `latexmk`, lancer `pdflatex` deux fois (pour la table des matières et le nombre de pages) :

```bash
mkdir build
pdflatex -output-directory=build main.tex
pdflatex -output-directory=build main.tex
```

### 5. Vérifier la compilation

La commande suivante ne doit rien afficher :

```bash
grep -nE "^!|Overfull|Underfull|not found" build/main.log
```

Le message « ignored error: Infinite glue shrinkage » produit par les tableaux coupés entre deux pages est sans effet sur le rendu.

### 6. Compiler la version 1.0 archivée

```bash
cd archives/v1.0-2026-10-16
latexmk
```

## Structure du dépôt

```
.
├── main.tex                 Document principal (uniquement des \input)
├── .latexmkrc               Configuration de latexmk (pdflatex, sortie dans build/)
├── besoins.txt              Expression des besoins, source du contenu fonctionnel
├── src/
│   ├── preamble/            packages, fonts, colors, layout, commands
│   ├── data/meta.tex        Titre, version, date, auteur, client, statut
│   └── sections/            Une section par fichier (NN-nom.tex)
├── assets/maquettes/        Maquettes filaires TikZ
├── docs/
│   ├── Page de garde.docx   Source Word de la page de garde
│   ├── page-de-garde.pdf    Export PDF, importé en page 1
│   └── archives/            Ancienne page de garde
├── archives/v1.0-2026-10-16/  Version 1.0 complète, compilable seule
└── build/main.pdf           Dernier PDF compilé
```

## Modifier le document

- **Métadonnées** (version, date, statut…) : `src/data/meta.tex`.
- **Contenu** : fichiers de `src/sections/`, inclus dans l’ordre par `main.tex`. Pour ajouter une section, créer `src/sections/NN-nom.tex` puis l’ajouter par `\input` dans `main.tex`.
- **Mise en forme** : uniquement dans `src/preamble/commands.tex`. Les sections n’utilisent que les commandes qui y sont définies (`\cdcsection`, `\cdcsubsection`, `\fichefonction`, `tableexigences`, `cdctableau`, `note`, `attention`, `cdcitems`…).

### Régénérer la page de garde

Après modification de `docs/Page de garde.docx`, réexporter le PDF depuis Word (Fichier › Exporter › PDF, sous le nom `docs/page-de-garde.pdf`), ou sous Windows avec PowerShell :

```powershell
$w = New-Object -ComObject Word.Application; $d = $w.Documents.Open("$PWD\docs\Page de garde.docx", $false, $true)
$d.ExportAsFixedFormat("$PWD\docs\page-de-garde.pdf", 17); $d.Close($false); $w.Quit()
```

Puis recompiler avec `latexmk`.

## Auteurs

Équipe projet Qribna – Module de génie logiciel, INSEA.
