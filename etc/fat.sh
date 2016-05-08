#!/bin/sh
# luisrios.eti.br/public/en_us/projects/yafs

if [ "$#" != 1 ]
then
  cat <<+
SYNOPSIS
  fat.sh [drive]

EXAMPLE
  fat.sh E:
+
  exit
fi

cd /tmp
yafs -r -d "$1" -f 1.xml

# FIXME support top level files too, not just directories
awk '
{
  z[NR] = $0
}
/^...short_name/ {
  y[$0]
}
END {
  PROCINFO["sorted_in"] = "@ind_num_asc"
  for (x in y)
    y[x] = ++w
  for (x in z)
    if (z[x] ~ /^..file/)
      printf "\t<file order=\"0\" volume=\"true\">\n"
    else if (z[x] ~ /^..directory/)
      printf "\t<directory order=\"%d\">\n", y[z[x+1]]
    else
      print z[x]
}
' 1.xml > 2.xml

yafs -w -d "$1" -f 2.xml
