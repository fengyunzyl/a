#!/usr/bin/awk -f
BEGIN {
  if (ARGC != 3) {
    print "bsa.awk GOOD BAD"
    exit
  }
  z = ARGV[1]
  y = ARGV[2]
  while (1) {
    x = int((z + y) / 2)
    if (w[x]++)
      break
    print
    print x
    while (1) {
      printf "[g,b]? "
      getline v < "-"
      switch (v) {
      case "g":
        z = x
        break
      case "b":
        y = x
        break
      default:
        print
        print "g - good"
        print "b - bad"
        continue
      }
      break
    }
  }
}
