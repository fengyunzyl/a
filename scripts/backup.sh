# backup files

usage ()
{
  cp $0 /tmp
  echo "usage: /tmp/${0##*/}"
  exit
}

[ ${0::5} = /tmp/ ] || usage

mkdir cygwin
cd cygwin

for item in /mingw32 /usr/local ~/.bash_history
do
  set .${item%/*}
  mkdir -p $1
  mv $item $1
done
