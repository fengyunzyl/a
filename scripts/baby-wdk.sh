# create baby wdk
# http://microsoft.com/en-us/download/details.aspx?id=11800

warn () {
  printf '\e[36m%s\e[m\n' "$*"
}

log () {
  unset PS4
  qq=$(( set -x
         : "$@" )2>&1)
  warn "${qq:2}"
  eval "${qq:2}"
}

deps=(
  wdk/buildtools_x86fre.msi
  wdk/buildtools_x86fre_cab001.cab
  wdk/headers.msi
  wdk/headers_cab001.cab
  wdk/libs_x64fre.msi
  wdk/libs_x64fre_cab001.cab
)

log 7z x $HOMEDRIVE/$USERNAME/public/wdk/GRMWDK_EN_7600_1.ISO ${deps[*]}
mv wdk baby-wdk
cd ${0%/*}
set $(git log --follow --oneline $0 | wc -l)
cd -
zip -9mr baby-wdk-$1.zip baby-wdk
