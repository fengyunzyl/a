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

  y["4CHANGE ENERGY"] # M-F 9-5
  y["DISCOUNT POWER"] # M-F 830-530
  y["FRONTIER UTILITIES"] # hours not listed
  y["PENNYWISE POWER"] y["PENNYWISE POWER "] # M-F 8-5
  y["POWER EXPRESS"] # $2/mo for manual bill pay
  y["SPARK ENERGY LLC"] # 2 stars

  # new customers only
  x["Gexa Choice Conserve 5"]
  x["Smart Saver 6"]
  x["Reliant Conservation (SM) 12 plan"]
  x["6 Month Usage Bill Credit"]
  x["Reliant Conservation (SM) 9 plan"]
  x["Pollution Free Conserve 12 Choice"]
  x["Smart Saver 3"]
  x["Gexa Choice 6"]
  x["Pollution Free Conserve 6 Choice"]
}
NR == 1 {
  for (i=1; i<=NF; i++)
    w[$i] = i
}
$w["Rate Type"] == "Fixed" {
  for (i in y)
    if ($w["RepCompany"] == i)
      next
  for (i in x)
    if ($w["Plan Name"] == i)
      next
  tot = 0
  for (i in z)
    if (z[i] >= 1000)
      tot += $w["Price/kWh 1000"] * z[i]
    else
      tot += $w["Price/kWh 500"] * z[i]
  t[1][NR] = tot
  t[2][NR] = $w["RepCompany"]
  t[3][NR] = $w["Price/kWh 500"]
  t[4][NR] = $w["Price/kWh 1000"]
}
END {
  PROCINFO["sorted_in"] = "@val_num_asc"
  for (i in t[1])
    printf "$%.0f - %s - 500 kWh %s - 1000 kWh %s\n",
    t[1][i], t[2][i], t[3][i], t[4][i]
}
