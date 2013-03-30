# create baby wdk
# http://microsoft.com/en-us/download/details.aspx?id=11800

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

log ()
{
  unset PS4
  set $((set -x; : "$@") 2>&1)
  shift
  warn $*
  eval $*
}

deps=(
  wdk/buildtools_x86fre.msi
  wdk/buildtools_x86fre_cab001.cab
  wdk/headers.msi
  wdk/headers_cab001.cab
  wdk/libs_x64fre.msi
  wdk/libs_x64fre_cab001.cab
)

P7ZIP="${ProgramW6432}/7-zip/7z"
log "$P7ZIP" x $HOMEDRIVE/steven/public/wdk/GRMWDK_EN_7600_1.ISO ${deps[*]}
mv wdk baby-wdk
cd ${0%/*}
set $(git log --follow --oneline $0 | wc -l)
cd -
"$P7ZIP" a -mx=9 baby-wdk-${1}.zip baby-wdk
rm -r baby-wdk
