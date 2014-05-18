# install notepad2
# you must do full clone to get correct version
# number on about page
git clone git://github.com/XhmikosR/notepad2-mod
cd notepad2-mod
sed -bi 's/sc.Match("$((")/& || sc.Match("$(")/' scintilla/lexers/lexbash.cxx

# build
cd build
export WDKBASEDIR=$HOMEDRIVE/winddk/7600.16385.win7_wdk.100208-1538
powershell saps build_wdk '"build x64"'
cd -

# install
cd bin/wdk/release_x64
set "$PROGRAMFILES"/notepad2
mkdir -p "$1"
cp notepad2 "$1"
{
  echo [notepad2]
  echo notepad2.ini=%appdata%/notepad2/notepad2.ini
} > "$1"/notepad2.ini
