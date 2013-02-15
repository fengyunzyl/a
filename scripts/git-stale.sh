#!/bin/sh
# list files by last commit date

ls | while read aa
do
  printf . >&2
  git log -1 --format="%ai  $aa" "$aa"
done > bb

echo
sort bb
rm bb
