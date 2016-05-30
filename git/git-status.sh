#!/bin/dash -e
for j in /Git/*/
do
  printf '\33c'
  cd "$j"
  git status
  printf '\33[1;35m%s\33[m\n' "${j%/}"
  read k
done
