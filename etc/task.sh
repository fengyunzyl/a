#!/bin/dash
if [ "$#" = 0 ]
then
  cat <<+
task.sh query

task.sh create minute 45 'hello world'
task.sh create once 23:59 'hello world'
task.sh create sun,tue,thu 23:59 'hello world'

task.sh delete 'hello world'
+
  exit
fi
case $1 in
query)
  schtasks /query /v /fo list |
  awk '
  BEGIN {
    FS = ":  "
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
        print xr["Start Time"][wh]
        print xr["Start Date"][wh]
        print xr["Days"][wh]
        print xr["Repeat: Every"][wh]
      }
    }
  }
  '
;;
create)
  case $2 in
  minute)
    schtasks /create /tn "$4" /tr "msg * /time 2000 $4" \
    /sc minute /mo "$3"
  ;;
  once)
    schtasks /create /tn "$4" /tr "msg * /time 2000 $4" \
    /sc once /st "$3"
  ;;
  *)
    schtasks /create /tn "$4" /tr "msg * /time 2000 $4" \
    /sc weekly /st "$3" /d "$2"
  ;;
  esac
;;
delete)
  schtasks /delete /tn "$2"
;;
esac
