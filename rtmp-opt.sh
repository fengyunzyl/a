#!/bin/sh
# Optimize RTMP string

warn()
{
  echo -e "\e[1;35m$1\e[m"
  read
}

warn 'Enter full RtmpDump command.'
declare -a aa="($REPLY)"
declare -A ab

while getopts "C:W:a:f:o:p:r:vy:" opt "${aa[@]:1}"
  do
    ab[$opt]="$OPTARG"
  done

set -x
rtmpdump -o a.flv -i "${ab[r]} playpath=${ab[y]}" ||
rtmpdump -o a.flv -i "${ab[r]} playpath=${ab[y]} live=1" ||
rtmpdump -o a.flv -i "${ab[r]} playpath=${ab[y]} app=${ab[a]}" ||
rtmpdump -o a.flv -i "${ab[r]} playpath=${ab[y]} pageUrl=${ab[p]}"
