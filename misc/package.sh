# check usage of a package by searching local repos

if (( $# != 1 ))
then
  echo ${0##*/} REGEX
  echo check usage of a package by searching local repos
  exit
fi

# commented results ok
egrep -r --color --exclude-dir .git "^(|.*[^.\"])$1" /srv/{a,dotfiles}
