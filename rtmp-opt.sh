#!/bin/sh
# Optimize RTMP string

warn()
{
  echo -e "\e[1;35m$@\e[m"
}

try()
{
  warn "$@"
  eval "$@"
}

warn 'Enter full RtmpDump command.'
read
declare -a aa="($REPLY)"

while getopts "C:RT:W:a:f:o:p:r:vy:" opt "${aa[@]:1}"
  do
    declare _$opt="$OPTARG"
  done

# strip -p
_p=${_p%/*}
_p=${_p/www.}
# strip -r
_r=${_r/:1935\//\/}
_r=${_r%/}
# strip -y
_y=${_y%.mp4}

try rtmpdump -o a.flv -i "$_r/$_y" ||
try rtmpdump -o a.flv -i "\"$_r/$_y app=$_a\"" ||
try rtmpdump -o a.flv -i "\"$_r/$_y live=1\"" ||
try rtmpdump -o a.flv -i "\"$_r/$_y pageUrl=$_p\"" ||
try rtmpdump -o a.flv -i "\"$_r playpath=$_y\"" ||
try rtmpdump -o a.flv -i "\"$_r/$_y token=$_T\""
