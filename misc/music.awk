#!/usr/bin/awk -f
BEGIN {
  if (ARGC != 5) {
    print "music.awk [views] [year] [month] [day]"
  }  

  # get age in seconds
  y = systime() - mktime(ARGV[2] " " ARGV[3] " " ARGV[4] " 0 0 0")

  # age in days
  x = y / (60 * 60 * 24)

  printf "input: %d views / %d days = %d\n", ARGV[1], x, ARGV[1] / x
}
