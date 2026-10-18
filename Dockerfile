# Image de compilation du cahier des charges : TeX Live complet pour ce projet,
# sans rien installer d'autre que Docker sur la machine.
FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    HOME=/tmp \
    TEXMFVAR=/tmp/texmf-var

# latexmk (et Perl), pdflatex, babel-french, Caladea, TikZ, tcolorbox,
# titlesec, pdfpages, fancyhdr, lastpage, etc.
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      latexmk \
      texlive-latex-base \
      texlive-latex-recommended \
      texlive-latex-extra \
      texlive-fonts-recommended \
      texlive-fonts-extra \
      texlive-lang-french \
      texlive-pictures \
 && rm -rf /var/lib/apt/lists/* /usr/share/doc/*

WORKDIR /doc

# Par défaut : compilation avec la configuration de .latexmkrc (sortie dans build/)
CMD ["latexmk"]
