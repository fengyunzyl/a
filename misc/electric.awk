#!/usr/bin/awk -f
BEGIN {
  if (ARGC != 4) {
    print "electric.awk [500 kWh] [1000 kWh] [deposit]"
    exit
  }
  z["2015 05"] =  417
  z["2015 04"] =  457
  z["2015 03"] =  940
  z["2015 02"] = 1282
  z["2015 01"] = 1308
  z["2014 12"] = 1216
  z["2014 11"] = 1115
  z["2014 10"] =  611
  z["2014 09"] =  778
  z["2014 08"] = 1035
  z["2014 07"] =  954
  z["2014 06"] =  861
  PROCINFO["sorted_in"] = "@ind_num_desc"
  for (y in z) {
    if (z[y] >= 1000)
      x = ARGV[2] * z[y]
    else
      x = ARGV[1] * z[y]
    printf "%s: $%.0f\n", y, x
    tot += x
  }
  printf "total with deposit: $%.0f\n", tot + ARGV[3]
}
