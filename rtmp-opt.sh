#!/bin/sh
# Optimize RTMP string

warn()
{
  echo -e "\e[1;35m$1\e[m"
}

try()
{
  warn "$1"
  eval "$1"
}

warn 'Enter full RtmpDump command.'
read
declare -a aa="($REPLY)"

while getopts "C:W:a:f:o:p:r:vy:" opt "${aa[@]:1}"
  do
    declare _$opt="$OPTARG"
  done

try "rtmpdump -o a.flv -i \"$_r playpath=$_y\"" ||
try "rtmpdump -o a.flv -i \"$_r playpath=$_y live=1\"" ||
try "rtmpdump -o a.flv -i \"$_r playpath=$_y app=$_a\"" ||
try "rtmpdump -o a.flv -i \"$_r playpath=$_y pageUrl=$_p\""
