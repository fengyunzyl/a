# install notepad2

git clone --depth 1 git://github.com/XhmikosR/notepad2-mod.git
cd notepad2-mod
# patch
set 'ChangeState(' SCE_SH_BACKTICKS SCE_SH_DEFAULT
sed -bi "0,/${1}${2}/s//${1}${3}/" scintilla/lexers/lexbash.cxx
# build
cd build
export WDKBASEDIR="$HOMEDRIVE/winddk/7600.16385.win7_wdk.100208-1538"
$WINDIR/system32/cmd /c build_wdk.bat Build x64
