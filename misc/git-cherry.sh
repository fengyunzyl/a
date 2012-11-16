#!/bin/sh
# Keep trying until clean merge

warn()
{
  echo -e "\e[1;35m$1\e[m"
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
