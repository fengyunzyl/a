# install notepad2
# you must do full clone to get correct version
# number on about page
git clone git://github.com/XhmikosR/notepad2-mod
cd notepad2-mod
sed -bi 's/sc.Match("$((")/& || sc.Match("$(")/' scintilla/lexers/lexbash.cxx

# build
cd build
export WDKBASEDIR=$HOMEDRIVE/winddk/*
chmod +x build_wdk.bat
cygstart -o build_wdk.bat build x64
cd -

# install
cd bin/wdk/release_x64
set "$PROGRAMFILES"/notepad2
mkdir -p "$1"
cp notepad2 "$1"
rw=(
  [notepad2]
  notepad2.ini=%appdata%/notepad2/notepad2.ini
)
printf '%s\n' ${rw[*]} > "$1"/notepad2.ini
