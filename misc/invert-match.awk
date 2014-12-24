#!/usr/bin/awk -f
@include "ord"
BEGIN {
  FS = ""
  for (z=0x21; z<=0x7e; z++)
    y[chr(z)]
}
{
  for (;NF;NF--)
    y[$NF]++
}
END {
  for (x in y)
    if (! y[x])
      printf x
}
