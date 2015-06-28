#!/usr/bin/awk --file
BEGIN {
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
}
NR == 1 {
  for (y=1; y<=NF; y++) {
    if ($y == "Price/kWh 500")
      p500 = y
    if ($y == "Price/kWh 1000")
      p1000 = y
    if ($y == "RepCompany")
      rc = y
    if ($y == "Rate Type")
      rt = y
  }
}
$rt == "Fixed" {
  tot = 0
  for (y in z) {
    if (z[y] >= 1000)
      x = $p1000 * z[y]
    else
      x = $p500 * z[y]
    tot += x
  }
  w[1][NR] = tot
  w[2][NR] = $rc
  w[3][NR] = $p500
  w[4][NR] = $p1000
}
END {
  PROCINFO["sorted_in"] = "@val_num_asc"
  for (s in w[1])
    printf "$%.0f - %s - 500 kWh %s - 1000 kWh %s\n",
    w[1][s], w[2][s], w[3][s], w[4][s]
}
