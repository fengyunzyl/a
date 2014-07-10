# install notepad2
sc=$PWD/notepad2-mod
ds=$PROGRAMFILES/notepad2

# you must do full clone to get correct version
# number on about page
git clone git://github.com/XhmikosR/notepad2-mod
cd "$sc"
curl -L github.com/XhmikosR/notepad2-mod/commit/48efb00.diff | git apply
cd "$sc/build"
cmd /c build_vs2013 build x64

# install
cd "$sc/bin/vs2013/release_x64"
install -D notepad2 "$ds/notepad2"
cat > "$ds/notepad2.ini" <<+
[notepad2]
notepad2.ini=$APPDATA/notepad2/notepad2.ini
+
