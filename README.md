# Cahier des charges – Reparé’Lik

Cahier des charges du projet **Reparé’Lik**, rédigé en LaTeX dans le cadre du module de génie logiciel (M2SI, INSEA).

Reparé’Lik est une plateforme web qui relie les clients, les réparateurs et les propriétaires de boutiques de réparation de téléphones au Maroc : gestion des réparations, géolocalisation des boutiques, suivi par WhatsApp, paiement et statistiques du marché. L’expression des besoins de l’équipe se trouve dans [`besoins.txt`](besoins.txt).

| Version | Date | État | PDF |
|---|---|---|---|
| 2.0 | 16/10/2026 | En cours de rédaction | [`build/main.pdf`](build/main.pdf) |
| 1.0 | 16/10/2026 | Terminée (archivée) | [`archives/v1.0-2026-10-16/cahier-des-charges-v1.0.pdf`](archives/v1.0-2026-10-16/cahier-des-charges-v1.0.pdf) |

## Démarrage rapide (Docker, recommandé)

Avec Docker, il n’y a **rien d’autre à installer** : LaTeX, les paquets et la police sont fournis par l’image, à l’identique sur tous les ordinateurs.

**Sur un nouveau PC, installer :**

| Outil | Rôle | Windows | Linux (Debian/Ubuntu) | macOS |
|---|---|---|---|---|
| Git | Récupérer le dépôt | `winget install Git.Git` | `sudo apt install git` | `xcode-select --install` |
| Docker | Compiler sans installer LaTeX | `winget install Docker.DockerDesktop` | [Docker Engine](https://docs.docker.com/engine/install/) | [Docker Desktop](https://www.docker.com/products/docker-desktop/) |

Sous Windows, Docker Desktop demande WSL 2 : accepter son installation au premier lancement (ou lancer `wsl --install`), puis redémarrer. Docker Desktop doit être **démarré** avant chaque compilation.

**Puis, dans un terminal :**

```bash
git clone https://github.com/BassirouKadade/cahier-des-charges-qribna.git
cd cahier-des-charges-qribna
docker compose run --rm pdf
```

La première commande `docker compose` construit l’image (une seule fois, environ 10 minutes et 2 Go selon la connexion). Les suivantes compilent en quelques secondes. Le PDF est produit dans `build/main.pdf`.

| Commande | Effet |
|---|---|
| `docker compose run --rm pdf` | Compile `build/main.pdf` |
| `docker compose run --rm watch` | Recompile à chaque enregistrement d’un fichier (arrêt : Ctrl+C) |
| `docker compose run --rm pdf latexmk -g` | Force une recompilation complète |
| `docker compose run --rm pdf latexmk -c` | Supprime les fichiers auxiliaires |
| `docker compose build --no-cache pdf` | Reconstruit l’image (après modification du `Dockerfile`) |

L’image est définie dans [`Dockerfile`](Dockerfile) (Debian 13, TeX Live) et [`compose.yaml`](compose.yaml). Le dossier du projet est monté dans le conteneur : les fichiers modifiés sur le PC sont compilés directement.

## Installation sans Docker

À suivre seulement si l’on préfère installer LaTeX sur l’ordinateur.

### Outils à installer

| Outil | Rôle | Obligatoire |
|---|---|---|
| Git | Récupérer et versionner le dépôt | Oui |
| Distribution LaTeX (MiKTeX, TeX Live ou MacTeX) | `pdflatex` et les paquets | Oui |
| Perl | Nécessaire à `latexmk` | Oui (déjà présent sous Linux et macOS) |
| Visual Studio Code + extension LaTeX Workshop | Éditer et prévisualiser | Non, conseillé |
| Microsoft Word | Modifier la page de garde (`docs/Page de garde.docx`) | Non |
| GitHub CLI (`gh`) | Publier sur GitHub | Non |

### Windows

Dans PowerShell :

```powershell
winget install Git.Git
winget install MiKTeX.MiKTeX
winget install StrawberryPerl.StrawberryPerl
winget install Microsoft.VisualStudioCode   # facultatif
winget install GitHub.cli                   # facultatif
```

Fermer puis rouvrir le terminal pour que les nouveaux programmes soient trouvés. Ensuite, mettre MiKTeX à jour et installer les paquets du document :

```powershell
miktex packages update
miktex packages install latexmk babel-french caladea fontaxes mweights microtype xcolor etoolbox tools booktabs enumitem pgf titlesec pdfpages eso-pic fancyhdr lastpage tcolorbox hyperref
```

Il est aussi possible d’autoriser l’installation automatique des paquets manquants : MiKTeX Console › Settings › « Always install missing packages on-the-fly ». En cas de `File 'x.sty' not found`, lancer `miktex packages install x`, puis recompiler.

### Linux (Debian, Ubuntu)

```bash
sudo apt update
sudo apt install git latexmk texlive-latex-base texlive-latex-recommended \
  texlive-latex-extra texlive-fonts-recommended texlive-fonts-extra \
  texlive-lang-french texlive-pictures
```

### macOS

```bash
brew install --cask mactex-no-gui
brew install git
```

MacTeX contient tous les paquets nécessaires, dont `latexmk`.

### Compiler

```bash
git clone https://github.com/BassirouKadade/cahier-des-charges-qribna.git
cd cahier-des-charges-qribna
latexmk          # compilation (configuration dans .latexmkrc)
latexmk -g       # force une recompilation complète
latexmk -pvc     # recompile à chaque enregistrement
latexmk -c       # supprime les fichiers auxiliaires
```

Sans `latexmk`, lancer `pdflatex` deux fois (pour la table des matières et le nombre de pages) :

```bash
mkdir build
pdflatex -output-directory=build main.tex
pdflatex -output-directory=build main.tex
```

## Vérifier la compilation

La commande suivante ne doit rien afficher :

```bash
grep -nE "^!|Overfull|Underfull|not found" build/main.log
```

Le message « ignored error: Infinite glue shrinkage » produit par les tableaux coupés entre deux pages est sans effet sur le rendu. Le log doit mentionner les fichiers `Caladea-*.pfb` : c’est la police du document (clone libre de Cambria, la police de la page de garde).

## Compiler la version 1.0 archivée

```bash
cd archives/v1.0-2026-10-16
latexmk
```

Avec Docker, depuis la racine du dépôt :

```bash
docker compose run --rm -w /doc/archives/v1.0-2026-10-16 pdf
```

## Structure du dépôt

```
.
├── main.tex                 Document principal (uniquement des \input)
├── .latexmkrc               Configuration de latexmk (pdflatex, sortie dans build/)
├── Dockerfile, compose.yaml Environnement de compilation Docker
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

Puis recompiler.

## Auteurs

Équipe projet Reparé’Lik – Module de génie logiciel, INSEA.
