#!/bin/bash
# Find large files in git repo, that dont exist in HEAD
# stackoverflow.com/questions/298314

red(){
  printf "\e[1;31m%s\e[m\n" "$1"
}

declare -A big_files
big_files=()
red 'Printing results'

while read commit; do
  while read bits type sha size path; do
    [ $size -gt 100000 ] && big_files[$sha]="$path $size"
  done < <(git ls-tree -rl $commit)
done < <(git rev-list HEAD)

for file in "${big_files[@]}"; do
  read path size <<< "$file"
  git cat-file -e HEAD:$path 2>/dev/null || echo $file 
done
