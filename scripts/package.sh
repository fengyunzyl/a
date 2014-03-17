if (( $# != 2 ))
then
  rw=(
    "${0##*/} MODE REGEX"
    ""
    "MODES"
    "   local     check usage of a package by searching local repos"
    "   require   print packages that require REGEX"
  )
  printf '%s\n' "${rw[@]}"
  exit
fi

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
esac
