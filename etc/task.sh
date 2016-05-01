#!/bin/dash
if [ $# = 0 ]
then
cat <<+
SYNOPSIS
  task.sh query
  task.sh create <schedule> <start time> <message>
  task.sh delete <name>

SCHEDULE
  once
  sun,tue,thu

START TIME
  23:59
+
  exit
fi
case "$1" in
query)
  schtasks | awk '!/Folder: \\Microsoft/' RS='\n\n'
;;
create)
  if [ "$2" = once ]
  then
    schtasks /create /tn "$4" /tr "msg * $4" /st "$3" /sc once
  else
    schtasks /create /tn "$4" /tr "msg * $4" /st "$3" /sc weekly /d "$2"
  fi
;;
delete)
  schtasks /delete /tn "$2"
;;
esac
