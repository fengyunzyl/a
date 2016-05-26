#!/usr/bin/awk -f
# weekday am = arrive by 730a, average
# weekday pm = depart at 5p, average
{
  fo[$1] = $2
}
END {
  go = \
  fo["mon-am"] + fo["mon-pm"] + fo["tue-am"] + fo["tue-pm"] + fo["wed-am"] + \
  fo["wed-pm"] + fo["thu-am"] + fo["thu-pm"] + fo["fri-am"] + fo["fri-pm"]
  ho = fo["rent"] * 80 * 60 / fo["paycheck"]
  printf "weekday = %d\n", go * 4
  printf "rent = %d\n", ho
  printf "monthly time expense = %d minutes\n", go * 4 + ho
}
