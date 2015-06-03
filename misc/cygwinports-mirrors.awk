#!/usr/bin/awk -f
BEGIN {
  FS = "\""
  while ("wget -qO- sourceware.org/mirrors.html" | getline) {
    if (/<li>/ && /http:/) {
      print $2
      if (system("wget --quiet --spider --tries 1 --timeout .2 " $2))
        continue
      alpha[$2] = length($2)
    }
  }
  printf "\nGOOD MIRRORS\n"
  PROCINFO["sorted_in"] = "@val_num_asc"
  for (bravo in alpha)
    print bravo
}
