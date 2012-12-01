#!/bin/sh
# Optimize RTMP string

warn ()
{
  echo -e "\e[1;35m$@\e[m"
}

try ()
{
  unset gh
  for gg
    do
      [[ "$gg" =~ [\ \&] ]] && gg="\"$gg\""
      gh+=("$gg")
    done
  warn "${gh[@]}"
  eval "${gh[@]}"
}

usage ()
{
  warn "Usage:  ${0##*/} COMMAND"
  exit
}

[ $1 ] || usage
shift

while getopts "C:RT:W:a:b:f:j:o:p:r:vy:" opt
  do
    declare _$opt="$OPTARG"
  done

_p=${_p%/*}
_p=${_p/www.}
_r=${_r/:1935\//\/}
_r=${_r%/}
_y=${_y%.mp4}
_j=${_j//\"/\\\"}
_j=${_j// /\\20}

# If you use live flag on non-live, it takes forever to time out.
try rtmpdump -o a.flv -i "$_r/$_y" ||
try rtmpdump -o a.flv -i "$_r/$_y app=$_a" ||
try rtmpdump -o a.flv -i "$_r/$_y pageUrl=$_p" ||
try rtmpdump -o a.flv -i "$_r playpath=$_y" ||
try rtmpdump -o a.flv -i "$_r/$_y token=$_T" ||
try rtmpdump -o a.flv -i "$_r/$_y live=1" ||
try rtmpdump -o a.flv -i "$_r/$_y swfUrl=$_W jtv=$_j" ||
try rtmpdump -o a.flv -i "$_r/$_y swfUrl=$_W live=1"
