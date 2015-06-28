#!/usr/bin/awk --file
BEGIN {
  if (ARGC != 2) {
    print "electric.awk [file]"
    exit
  }
  FS = ","
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
}
NR == 1 {
  for (y=1; y<=NF; y++) {
    if ($y == "Price/kWh 500")
      p500 = y
    if ($y == "Price/kWh 1000")
      p1000 = y
    if ($y == "RepCompany")
      rc = y
    if ($y == "Plan Name")
      pn = y
    if ($y == "Rate Type")
      rt = y
  }
}
$rt == "Fixed" {
  tot = 0
  for (x in z) {
    if (z[x] >= 1000)
      w = $p1000 * z[x]
    else
      w = $p500 * z[x]
    tot += w
  }
  printf "%.0f - %s - %s\n", tot, $rc, $pn
}
