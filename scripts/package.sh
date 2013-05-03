# check usage of a package

usage ()
{
  echo "usage: ${0##*/} MODE REGEX"
  echo
  echo "MODES"
  echo
  echo "local"
  echo "  search local repos for REGEX"
  echo "require"
  echo "  print packages that require REGEX"
  echo "contain"
  echo "  print packages that contain REGEX"
  exit
}

[ $2 ] || usage
mode=$1
regex=$2

if [ $mode = local ]
then
  # commented results ok
  egrep -r --color --exclude-dir .git "^(|.*[^.\"])$regex" /opt/{a,dotfiles}
elif [ $mode = require ]
then
  awk '
  /^@ / {
    foo=$2
  }
  $0 ~ "^requires:.*"bar {
    print foo
  }
  ' bar=$regex /usr/local/bin/http*/setup.ini
elif [ $mode = contain ]
then
  cygcheck -p $regex | awk 'NR>1 && ! /-src\t/ && ! a[$1]++ {print $1}' FS=/
fi
