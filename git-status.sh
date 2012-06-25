#!/bin/sh
# stackoverflow.com/questions/961101
# This requires "ncurses" package

# need trailing slash to filter out files
for i in /c/home/GitHub/*/; do
    clear
    cd $i
    git status
    printf "\n$i"
    read
done
