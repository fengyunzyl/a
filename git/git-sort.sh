#!/bin/dash

sort_size() {
  find -type f -printf '%s\t%f\n' | sort -nr
}

sort_date() {
  qu=`mktemp`
  for pa in *
  do
    printf . >&2
    git log -1 --follow --diff-filter=AM --format="%ai%x09$pa" "$pa"
  done > $qu
  echo
  sort -r $qu
}

sort_commits() {
  qu=`mktemp`
  for pa in *
  do
    printf . >&2
    git log --follow --format=format:"$pa" "$pa" | awk 'END {print NR "\t" $0}'
  done > $qu
  echo
  sort -nr $qu
}

case "$1" in
size) sort_size ;;
date) sort_date ;;
commits) sort_commits ;;
*)
  cat <<+
SYNOPSIS
  git sort.sh [key]

KEYS
  size
    sort by file size

  date
    sort by date of last commit, not including renames

  commits
    sort by number of commits, including renames
+
;;
esac
