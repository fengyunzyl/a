#!/bin/sh
# Keep trying until clean merge

warn()
{
  echo -e "\e[1;35m$1\e[m"
}

git cherry svnpenn master | while read
  do
    sha=${REPLY:2:5}
    git merge $sha ||
      {
        warn "$sha bad!"
        git reset --hard
        git merge -X ours $sha
      }
  done

# git merge -X patience master
# cp ../rtmpsrv.c .
# cp ../rtmp.c librtmp
# cp ../parseurl.c librtmp
# git commit -a
