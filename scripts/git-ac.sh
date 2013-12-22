# we need a catch in case $1 is nonsense
if (( $# ))
then
  git add $1
else
  git add -A
fi

# print first added line if found, else print first removed line
b=$(git diff --cached | awk '
  /^+[^+]/       {m=$0;exit}
  /^-[^-]/ && !m {m=$0}
  END            {sub(/^[-+# ]+/, "", m); print m}
')

git commit -m "$b"
