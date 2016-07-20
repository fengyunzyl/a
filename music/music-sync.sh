#!/bin/dash -e
fd() {
  find %-new %-old -type f -printf '%f\n'
}

mr() {
  mkdir -p % %-new %-old
  touch %/h.txt %/f.txt %/c.txt
}

if [ "$#" != 1 ]
then
  cat <<+
SYNOPSIS
  music-sync.sh [target]

DESCRIPTION
  Sync files to target flash drive, and record all files transferred. If target
  is ‘list’, list available flash drives and changes since last sync; else
  target should be path to flash drive.
+
  exit
fi

mr

if [ "$1" = list ]
then
  fd > %/c.txt
  echo CHANGES SINCE LAST SYNC
  if ! git diff --color %/f.txt %/c.txt | awk '
  BEGIN          {z = 1}
  /^\33\[3[12]m/ {z = 0; print}
  END            {exit z}
  '
  then
    echo no changes since last sync
  fi
  echo
  echo AVAILABLE FLASH DRIVES
  if ! awk '
  BEGIN        {z = 1}
  $3 == "vfat" {z = 0; print $2}
  END          {exit z}
  ' /etc/mtab
  then
    echo no flash drives found
  fi
else
  rsync --archive --delete --verbose --modify-window 2 %-new %-old "$1"
  fd > %/f.txt
fi
