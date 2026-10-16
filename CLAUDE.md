# Cahier des charges (LaTeX)

## Compilation
- `latexmk` à la racine (pdflatex, config dans `.latexmkrc`) ; `latexmk -g` force une recompilation complète.
- Sortie : `build/main.pdf` (+ auxiliaires dans `build/`).
- Contrôle : `grep -nE "^!|Overfull|Underfull|not found" build/main.log` doit être vide.
- Police attendue : Caladea, clone métrique de Cambria, la police de la page de garde Word (`Caladea-*.pfb` dans le log). Jamais de fontes bitmap `.pk`.

## Architecture
- `main.tex` : uniquement des `\input`.
- `src/preamble/` : `packages` (hyperref toujours en dernier), `fonts`, `colors`, `layout` (géométrie + fancyhdr), `commands` (toute la mise en forme).
- `src/data/meta.tex` : titre, nom de l’application, version, date, auteur, client, statut, chemin du PDF de garde (`\doc...`).
- `src/sections/NN-nom.tex` : une section par fichier, ajoutée par `\input` dans `main.tex`. Ordre : 00 page de garde, 01 table des matières, 02-03 sections non numérotées (historique, glossaire), 04-12 sections numérotées 1 à 9 réparties en trois parties, 13 annexes. Le plan suit le modèle de cahier des charges fourni par le professeur : contexte et problème, objectifs, périmètre, description fonctionnelle, contraintes et exigences, maquettes, enveloppe budgétaire, délais et livrables, évaluation des résultats, annexe des PV de réunions.
- `archives/v1.0-2026-10-16/` : version 1.0 complète (27 pages), compilable seule (`latexmk` dans le dossier), PDF dans `cahier-des-charges-v1.0.pdf`. Ne pas modifier.
- Version 2.0 en cours (depuis le 16/10/2026) : page de garde terminée ; table des matières et squelette des titres en place (plan validé par l’utilisateur : 1 Contexte et définition du problème … 8 Critères et indicateurs d’évaluation, Conclusion, Annexes A Glossaire / B Procès-verbaux). Fichiers inclus : `00-page-de-garde`, `01-table-des-matieres`, `02-contexte-probleme`, `03-objectifs`, `04-perimetre`, `05-description-fonctionnelle`, `06-contraintes-exigences`, `07-enveloppe-budgetaire`, `08-delais-livrables`, `09-criteres-evaluation`, `10-conclusion`, `11-annexes`. Les autres fichiers de `src/sections/` et `assets/maquettes/` viennent de la v1 et ne sont plus inclus. Chaque `\cdcsection` / `\cdcsectionnonnum` commence une nouvelle page.
- `docs/Page de garde.docx` : source Word de la page de garde (projet Qribna). `docs/page-de-garde.pdf` est son export, importé tel quel en page 1. `docs/archives/` garde l’ancienne page de garde FISCALIA.
- `besoins.txt` : expression des besoins de l’équipe, source unique du contenu fonctionnel.
- `assets/maquettes/` : maquettes filaires TikZ (une par fichier), insérées par `\cdcmaquette` ou `\cdcmaquettes`.

## Régénérer la page de garde après modification du .docx (PowerShell)
```powershell
$w = New-Object -ComObject Word.Application; $d = $w.Documents.Open("$PWD\docs\Page de garde.docx", $false, $true)
$d.ExportAsFixedFormat("$PWD\docs\page-de-garde.pdf", 17); $d.Close($false); $w.Quit()
```

## Commandes (définies dans `src/preamble/commands.tex`)
- `\cdcsection{Titre}` : section numérotée « 1. Titre », gras noir 14 pt, sans icône ni pastille.
- `\cdcsectionnonnum{Titre}` : même style, sans numéro, présente dans la table des matières.
- `\cdcpartie{Titre}` : « PARTIE I – TITRE », regroupe des sections et commence une nouvelle page. Dans la table des matières, en capitales grasses sur un filet gris.
- `\cdcsubsection{Titre}` : « 1.1 Titre », gras noir 12 pt.
- `\cdcannexe{Titre}` : « Annexe A – Titre », après `\cdcsectionnonnum{Annexes}`.
- `\cdctabledesmatieres` : page « Table des matières » (titre gras centré, points de conduite), générée depuis les sections. Elle doit tenir sur une page.
- `\fichefonction{ID}{Intitulé}{Objectif}{Description}{Contraintes / règles de gestion}{Priorité}` : grille du professeur (partie 4.2), tableau insécable avec en-tête « Fonction ID – Intitulé » en marine.
- `\prioMust`, `\prioShould`, `\prioCould`, `\prioWont` : priorités MoSCoW, distinguées par la graisse ou l’italique.
- `\begin{tableexigences} ID & Exigence & Priorité & Source \\ \end{tableexigences}` : longtable avec en-tête répété.
- `\begin{note}…\end{note}`, `\begin{attention}…\end{attention}` : encadrés (fond blanc, filet marine à gauche).
- `\begin{cdctableau}{P{3cm}L}{\cdcth{A} & \cdcth{B}} … \end{cdctableau}` : tableau générique sécable (longtable). Colonnes `P{largeur}` et `L` (largeur restante partagée) uniquement. `\cdcsep` espace deux rangées.
- `\groupeexigences{Titre}` : rangée d’intertitre dans `tableexigences`.
- `\begin{cdcitems}\item …\end{cdcitems}` : puces compactes ; `cdcsousitems` (tirets) pour un second niveau ; `cdcetapes` pour une liste numérotée ; `cdccellitems` pour des puces dans une cellule.
- `\begin{cdcdefinitions}[largeur]\item[Terme] …\end{cdcdefinitions}` : liste de définitions (glossaire, objectifs).
- `\cdcintertitre{Titre}` : intertitre gras non numéroté, hors table des matières.
- `\cdcmaquette{fichier}{Légende}`, `\cdcmaquettes{f1}{L1}{f2}{L2}` : maquettes numérotées, seules ou côte à côte. Styles TikZ `mq …` définis dans `commands.tex`.
- `\cdcdetail{Libellé}{texte}` : ligne « **Libellé** : texte ».
- `\historique{\versionligne{v}{date}{auteur}{modifications} …}` : tableau des versions.
- `\cdclien{url}`, `\cdcemail{adresse}` : liens en bleu de lien.
- `\cdcpagedegarde` : importe `\docgarde` en pleine page (pdfpages) ; la numérotation arabe repart à 1 à la table des matières.

## Règles
- Couleurs : marine `primary` #163853, `onprimary` (texte sur marine), noir, blanc, bleu `lien` #0563C1. Aucune autre couleur d’accent. Le marine reste réservé à la page de garde, aux en-têtes de tableaux et au filet des encadrés ; texte et titres sont noirs.
- Aucune icône (ni dans les titres, ni dans la table des matières, ni dans les encadrés). On dit « table des matières », jamais « sommaire ».
- Pas de filet ni de soulignement sous les titres.
- Aucune mise en forme en dur dans `src/sections/` : uniquement les commandes ci-dessus.
- Corps en 11 pt (jamais moins de 10 pt), titres de section en 14 pt, marges de 2,5 cm, interligne 1,1. Pas de césure (`\hyphenpenalty=10000`). Ne pas activer l’expansion de microtype.
- Typographie : `~:` avant les deux-points, apostrophe ’. Pas de deux-points au milieu d’une phrase en prose.
- Ne pas inventer de contenu (fonctionnalités, chiffres, délais).
- Choisir la forme selon le contenu : paragraphes pour expliquer, listes pour énumérer, tableaux seulement pour des données à plusieurs dimensions (historique, résultats chiffrés, fiches de fonctions, exigences, planning, indicateurs). Jamais de tableau par défaut.

## Pièges
- Écrire et modifier les `.tex` UNIQUEMENT avec Write/Edit : heredoc, `echo` et `sed` mangent les antislashs (`\linespread` devient `\inespread`, sans erreur visible).
- MiKTeX n’installe pas les paquets à la volée : pour `File 'x.sty' not found`, lancer `miktex packages install <paquet>`, et relancer la commande en cas de timeout.
- `\headrule` personnalisé : rester sur une `\hrule` (une `\hbox` gonfle `\headheight`, ce qui déclenche un avertissement de fancyhdr).
- Dans les clés tcolorbox (`before upper`), une espace finale est supprimée : écrire `\ `.
- Le dernier argument de `\titlecontents` n’accepte pas `\par` : utiliser `\endgraf`.
- Styles de page : `cdc` (style courant) et `tdm` sont des `\fancypagestyle` autonomes. Revenir avec `\pagestyle{cdc}`, jamais avec `\pagestyle{fancy}`.
- Dépôt Git public : https://github.com/BassirouKadade/cahier-des-charges-qribna (branche `main`, via `gh`). Après chaque modification : recompiler, vérifier le log, puis `git add -A`, `git commit`, `git push` sans attendre que l’utilisateur le fasse. `build/main.pdf` est versionné, le reste de `build/` est ignoré.
- Les tableaux longtable coupés entre deux pages produisent « ignored error: Infinite glue shrinkage » (noyau LaTeX 2025) : sans effet sur le rendu. Ne pas utiliser xltabular (même message, plus des erreurs avec booktabs).
- TikZ : pas de `\ifnum`/`\ifcase` dans les options ou le corps d’un `\foreach` (boucle infinie à la compilation) ; passer les valeurs dans la liste du `\foreach`.
- `\hbadness=4000` : sans césure, les lignes justifiées légèrement espacées sont normales ; seules les vraies anomalies sont signalées.
