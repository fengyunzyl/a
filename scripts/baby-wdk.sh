# create baby wdk
# http://microsoft.com/en-us/download/details.aspx?id=11800

if [[ $OSTYPE =~ linux ]]
then
  P7ZIP=p7zip
else
  P7ZIP="${ProgramW6432}/7-zip/7z"
fi

deps=(
  wdk/buildtools_x86fre.msi
  wdk/buildtools_x86fre_cab001.cab
  wdk/headers.msi
  wdk/headers_cab001.cab
  wdk/libs_x64fre.msi
  wdk/libs_x64fre_cab001.cab
)

"$P7ZIP" x GRMWDK_EN_7600_1.ISO ${deps[*]}
mv wdk baby-wdk
cd ${0%/*}
set $(git log --follow --oneline $0 | wc -l)
cd -
tar acf baby-wdk-${1}.tar.gz baby-wdk
rm -r baby-wdk
