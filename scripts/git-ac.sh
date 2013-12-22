
# we need a catch in case $1 is nonsense
if (( $# ))
then
  git add $1
else
  git add -A
fi

b=$(git diff --cached | awk '/^[+-][^+-]/{print;exit}')
git commit -m "$b"
