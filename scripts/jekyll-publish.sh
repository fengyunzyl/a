# This script will push Jekyll branches.

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

log ()
{
  unset PS4
  qq=$((set -x; : "$@") 2>&1)
  warn "${qq:2}"
  eval "${qq:2}"
}

usage ()
{
  echo usage: $0 REPO
  exit
}

[ $1 ] || usage
cd /opt/$1

# Push source branch
log git checkout source
git add -A
git status -s | git commit -F-
git push origin source || exit

# Push master branch
jekyll build || exit
grep --color -r 'Liquid.error' . && exit

if ! [ -a /bin/coderay ]
then
  echo no coderay
  exit
fi

log git checkout master
git rm -qr .
cp -r _site/. .
rm -r _site
git add -A
git status -s | git commit -F-
git push origin master || exit
log git checkout source
echo 'Publish complete!'
