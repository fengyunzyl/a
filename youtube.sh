#!/bin/bash
# Bash download from YouTube
# http://www.youtube.com/watch?v=LHelEIJVxiE

qual=(
  [5]='FLV 240p H.263'
  [17]='3GP 144p'
  [18]='MP4 360p H.264 Baseline'
  [22]='MP4 720p H.264 High'
  [34]='FLV 360p H.264 Main'
  [35]='FLV 480p H.264 Main'
  [36]='3GP 240p'
  [37]='MP4 1080p H.264 High'
  [43]='WebM 360p VP8'
  [44]='WebM 480p VP8'
  [45]='WebM 720p VP8'
  [46]='WebM 1080p VP8'
  [82]='MP4 360p H.264 3D'
  [84]='MP4 720p H.264 3D'
  [100]='WebM 360p VP8 3D'
  [102]='WebM 720p VP8 3D'
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
wget -O videoplayback "$url&signature=$sig"
