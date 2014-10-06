#!/bin/bash
# Find large files in git repo, that dont exist in HEAD

if (( $# != 1 ))
then
  echo git large.sh SIZE
  exit
fi

declare -A big_files
big_files=()
echo printing results

while read commit
do
  while read bits type sha size path
  do
    if (( size > $1 ))
    then
      big_files[$sha]="$sha $size $path"
    fi
  done < <(git ls-tree --abbrev -rl $commit)
done < <(git rev-list HEAD)

for file in "${big_files[@]}"
do
  read sha size path <<< "$file"
  if git ls-tree -r HEAD | grep -q $sha
  then
    echo $file
  fi
done
