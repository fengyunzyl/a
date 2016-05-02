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
  hourly
  sun,tue,thu

START TIME
  23:59
+
  exit
fi
case "$1" in
query)
  schtasks /query /v /fo list |
  awk '
  BEGIN {
    FS = ":"
  }
  $1 == "HostName" {
    wh++
  }
  {
    xr[$1][wh] = $0
  }
  END {
    for (wh in xr["TaskName"]) {
      if (xr["TaskName"][wh] !~ "Microsoft|WPD") {
        if (ya++) print ""
        print xr["TaskName"][wh]
        print xr["Schedule Type"][wh]
        print xr["Start Time"][wh]
        print xr["Start Date"][wh]
        print xr["Days"][wh]
      }
    }
  }
  '
;;
create)
  case "$2" in
  hourly)
    schtasks /create /tn "$4" /tr "msg * /time 1000 $4" /st "$3" \
    /sc hourly
  ;;
  once)
    schtasks /create /tn "$4" /tr "msg * /time 1000 $4" /st "$3" \
    /sc once
  ;;
  *)
    schtasks /create /tn "$4" /tr "msg * /time 1000 $4" /st "$3" \
    /sc weekly /d "$2"
  ;;
  esac
;;
delete)
  schtasks /delete /tn "$2"
;;
esac
