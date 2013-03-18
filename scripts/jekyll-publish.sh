# This script will push Jekyll branches.

log ()
{
  unset PS4
  coproc yy (set -x; : "$@") 2>&1
  read zz <&$yy
  warn ${zz:2}
  "$@"
}

cd /opt/svnpenn.github.com

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
read aa < <(git status -s | cut -c4-)
git status -s | git commit -F-
git push origin master || exit
log git checkout source
echo 'Publish complete!'
