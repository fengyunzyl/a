#!/bin/dash -e
if git diff --cached --quiet
then
  git add --all "$@"
fi

# print first added line if found, else print first removed line
git diff --cached | awk '
/^i/ {
  y = NR
}
/^[-+]/ && NR>y+2 {
  if (/^-/ && z) next
  if (/#/) next
  z = $0
  if (/^+/ && z) exit
}
END {
  print substr(z, 2)
}
' |
git commit --file -
git commit --file -
