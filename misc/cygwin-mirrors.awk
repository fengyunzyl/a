#!/usr/bin/awk -f
BEGIN {
  FS = ";"
  while ("wget -qO- sourceware.org/cygwin/mirrors.lst" | getline) {
    print $1
    if (system("wget --quiet --spider --tries 1 --timeout .1 " $1))
      continue
    alpha[$1] = length($1)
  }
  printf "\nGOOD MIRRORS\n"
  PROCINFO["sorted_in"] = "@val_num_asc"
  for (bravo in alpha)
    print bravo
}
