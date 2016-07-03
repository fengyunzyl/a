#!/usr/bin/awk -f
# FIXME gasoline
# weekday am = arrive by 730a, average
# weekday pm = depart at 5p, average
{
  fo[$1] = $2
}
END {
  go = \
  fo["mon-am"] + fo["tue-am"] + fo["wed-am"] + fo["thu-am"] + fo["fri-am"] + \
  fo["mon-pm"] + fo["tue-pm"] + fo["wed-pm"] + fo["thu-pm"] + fo["fri-pm"]
  ho = fo["rent"] * 80 * 60 / fo["paycheck"]
  printf "weekday = %d\n", go * 4
  printf "rent = %d\n", ho
  printf "monthly time expense = %d minutes\n", go * 4 + ho
}
