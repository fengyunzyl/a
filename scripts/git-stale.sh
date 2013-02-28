#!/bin/sh
# for each file in current directory, print date of last
# commit (not including renames)

ls | while read aa
do
  printf . >&2
  git log --follow --name-status --format="%ai  $aa" "$aa" |
    sed 'h;N;N;/\nR/d;g;q'
done > bb

echo
sort bb
rm bb
