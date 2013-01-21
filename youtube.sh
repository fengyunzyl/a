#!/bin/bash
# Bash download from YouTube
# http://youtube.com/watch?v=LHelEIJVxiE
# http://youtube.com/watch?v=L7ird1HeEjw

qual=(
  [5]='240p FLV h.263'
  [17]='144p 3GP mpeg4 simple'
  [18]='360p MP4 h.264 baseline'
  [22]='720p MP4 h.264 high'
  [34]='360p FLV h.264 main'
  [35]='480p FLV h.264 main'
  [36]='240p 3GP mpeg4 simple'
  [37]='1080p MP4 h.264 high'
  [43]='360p WebM vp8'
  [44]='480p WebM vp8'
  [45]='720p WebM vp8'
  [46]='1080p WebM vp8'
  [82]='360p MP4 h.264 3D'
  [84]='720p MP4 h.264 3D'
  [100]='360p WebM vp8 3D'
  [102]='720p WebM vp8 3D'
)

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

usage ()
{
  echo usage: $0 [ITAG] URL
  exit
}

[ $1 ] || usage
[ $2 ] || set '' $1
arg_itag=$1
arg_url=$2

while read
do
  # raw URL decode
  printf -v video %b ${REPLY//%/\\x}
  # serialize data
  declare ${video//u0026/ }
  if ! [ $arg_itag ]
  then
    printf ' %3.3s  %s\n' $itag "${qual[itag]}"
  elif [ $arg_itag = $itag ]
  then
    break
  fi
done < <(wget -qO- $arg_url | tr '",' '\n' | grep sig=)

[ $arg_itag ] || usage
set "$url&signature=$sig" ${qual[itag],,}

while read
do
  if [[ $REPLY =~ Length:.([0-9]*) ]]
  then
    kill $!
    break
  fi
done < <(exec wget -O a.$3 "$1" 2>&1)

if [ ${BASH_REMATCH[1]} = 2147483646 ]
then
  wget --ignore-length -O a.$3 "$1"
else
  wget -O a.$3 "$1"
fi
