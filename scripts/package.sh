# check usage of a package

usage () {
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

(( $# == 2 )) || usage
mode=$1
regex=$2

case $mode in
local)
  # commented results ok
  egrep -r --color --exclude-dir .git "^(|.*[^.\"])$regex" /srv/{a,dotfiles}
  ;;
require)
  cd /usr/local/bin
  set $(du -d1 | sort -nr | awk 'NR==2 {print $2}')
  awk '
  /^@ / {
    foo=$2
  }
  $0 ~ "^requires:.*"bar {
    print foo
  }
  ' bar=$regex $1/x86_64/setup.ini
  ;;
contain)
  cygcheck -p $regex | awk 'NR>1 && !/-src\t/ && !a[$2]++ && $0=$2' FS=/
  ;;
esac
