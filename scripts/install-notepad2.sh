# install notepad2
# you must do full clone to get correct version
# number on about page
git clone git://github.com/XhmikosR/notepad2-mod
cd notepad2-mod
SOURCE=$PWD

# patch
sed -bi 's/sc.Match("$((")/& || sc.Match("$(")/' scintilla/lexers/lexbash.cxx

# build
cd build
export WDKBASEDIR="$HOMEDRIVE/winddk/7600.16385.win7_wdk.100208-1538"
cmd /c build_wdk.bat Build x64

# install
cd "$ProgramW6432"
mkdir -p notepad2
cd notepad2
cp $SOURCE/bin/wdk/release_x64/notepad2 .
cat > notepad2.ini <<q
[notepad2]
notepad2.ini=%appdata%/notepad2/notepad2.ini
q
