# http://w32tex.org

# latex.tar.xz  LaTeX 2011/06/27
# mftools.tar.xz  mktexmf, mktextfm, mktexpk and ps2pk
# platex.tar.xz  pLaTeX by ASCII MEDIA WORKS corp.
# ptex-w32.tar.xz  pTeX by ASCII MEDIA WORKS corp.
# web2c-lib.tar.xz  Basic library files of TeX
# web2c-w32.tar.xz  Binary files of TeX and its friends
set $HOMEDRIVE/tex ctan.ijs.si/mirror/w32tex/current
mkdir -p $1
cd $1

# pdflatex.exe
wget $2/pdftex-w32.tar.xz
# firefox
