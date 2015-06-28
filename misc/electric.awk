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
    if ($y == "Plan Name")
      pn = y
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
  w[$rc " - " $pn] = tot
}
END {
  PROCINFO["sorted_in"] = "@val_num_asc"
  for (v in w)
    printf "$%.0f - %s\n", w[v], v
}
