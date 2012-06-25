#!/bin/sh
# Enumerate special folder IDs

# CSIDL_CDBURN_AREA (0x003b) 59

for i in {0..59}; do
    folder="$(cygpath -F $i 2>&1)"
    test "$folder" = "${folder/failed/}" && echo "$i $folder"
done
