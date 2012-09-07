#!/bin/bash
# Find large files in git repo, that dont exist in HEAD
# stackoverflow.com/questions/298314

warn(){
  echo -e "\e[1;35m$1\e[m"
}

declare -A big_files
big_files=()
warn 'Printing results'

while read commit; do
  while read bits type sha size path; do
    [ $size -gt 100000 ] && big_files[$sha]="$sha $size $path"
  done < <(git ls-tree --abbrev -rl $commit)
done < <(git rev-list HEAD)

for file in "${big_files[@]}"; do
  read sha size path <<< "$file"
  git ls-tree -r HEAD | grep -q $sha || echo $file
done
