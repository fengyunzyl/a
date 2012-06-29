#!/bin/sh
# stackoverflow.com/questions/961101

purple(){
  printf "\e[1;35m%s\e[m" "$1"
}

# need trailing slash to filter out files
for i in ~/*/; do
  clear
  cd $i
  git status
  purple $i
  read
done
