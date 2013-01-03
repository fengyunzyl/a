#!/bin/sh
# Find merge conflicts

warn()
{
  printf "\e[1;35m%s\e[m\n" "$*"
}

git cherry pu master | while read
  do
    sha=${REPLY:2:5}
    git merge $sha ||
      {
        warn "$sha bad"
        git reset --hard
        git merge -X ours $sha
      }
  done
