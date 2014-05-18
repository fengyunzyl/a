# also known as chromaprint

set chromaprint-fpcalc-0.6-win32
wget bitbucket.org/acoustid/chromaprint/downloads/$1.zip
unzip $1.zip
cd $1
cp fpcalc /usr/local/bin
