#!/bin/bash
# Bash download from YouTube
# stream-recorder.com/forum/why-youtube-delivering-files-2mb-size-instead-t12117.html
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

download(){
  read host < <(cut -d/ -f3 <<< "$1")
  read path < <(cut -d/ -f4- <<< "$1")
  headers=(
    "GET /$path HTTP/1.1"
    "Connection: close"
    "Host: $host"
    ""
  )
  exec 3<>/dev/tcp/$host/80
  printf "%s\n" "${headers[@]}" >&3
  # A Redirect will cause this to fail, need to fix
  sed -b "1,/^\r/d" <&3 &
  pid=$!
  read < <(du -b | cut -f1)
  while [ -e /proc/$pid ]; do
    sleep .3
    du -b \
      | cut -f1 \
      | xargs -i% expr % - $REPLY \
      | xargs printf "%'.3d\r" \
      > /dev/stderr
  done
}

red(){
  printf "\e[1;31m%s\e[m\n" "$1"
}

die(){
  echo -e "\e[1;31m$1\e[m"
  exit
}

[ $1 ] || die "Usage: $0 http://www.youtube.com/..."

# Create array
videos=()
while read; do
  # Raw URL decode
  printf -v video "%b" "${REPLY//%/\\x}"
  videos+=("$video")
done < <(download "$1" | sed "s [=\] \n g" | grep "videoplayback%3F")

# Choose video
for i in "${!videos[@]}"; do
  printf "%s\t" "$i"
  : "${videos[i]}"
  : "${_#*itag=}"
  : "${_%%&*}"
  echo "${qual[_]}"
done

red 'Make choice.'; read
: "${videos[REPLY]}"
echo "$_"
download "$_" > videoplayback
