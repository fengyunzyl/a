#!/bin/dash -e
for j in /Git/*/
do
  cd "$j"
  if [ -e .git ]
  then
    printf '\33c'
    git status
    printf '\33[1;35m%s\33[m\n' "${j%/}"
    read k
  fi
done
