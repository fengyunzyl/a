# check usage of a package

usage ()
{
  echo usage: $0 COMMAND [INI]
  echo
  echo include INI to print packages that would install this package
  exit
}

[ $1 ] || usage
# commented results ok
egrep -r --color --exclude-dir .git "^(|.*[^.\"])$1" /opt/{a,dotfiles}

[ $2 ] || exit

awk '
/^@ / {
  foo=$0
}
$0 ~ "^requires:.*"bar {
  print foo"\n"$0"\n"
}
' bar="$1" /usr/local/bin/http%3a%2f%2fbox-soft.com%2f/setup.ini
