#!/bin/bash
# Bash download from YouTube
# stream-recorder.com/forum/why-youtube-delivering-files-2mb-size-instead-t12117.html
# http://www.youtube.com/watch?v=LHelEIJVxiE

attrget(){
  s="$1"
  s="${s#*$2=}" # Remove front
  s="${s%%&*}" # Remove back
  echo "$s"
}

download(){
  host="$1"
  host="${host#*//}"
  host="${host%/*}"
  exec 3<>/dev/tcp/$host/80
  headers=(
    "GET ${1#*$host} HTTP/1.1"
    "Connection: close"
    "Host: $host"
    ""
  )
  printf "%s\r\n" "${headers[@]}" >&3
  cat <&3
}

get_quality(){
  read qual < <(attrget "$1" "itag")
  case "$qual" in
    5) echo 'FLV 240p H.263';;
    18) echo 'MP4 360p H.264 Baseline';;
    22) echo 'MP4 720p H.264 High';;
    34) echo 'FLV 360p H.264 Main';;
    35) echo 'FLV 480p H.264 Main';;
    36) echo '3GP 240p';;
    37) echo 'MP4 1080p H.264 High';;
    43) echo 'WebM 360p VP8';;
    44) echo 'WebM 480p VP8';;
    45) echo 'WebM 720p VP8';;
    46) echo 'WebM 1080p VP8';;
    82) echo 'MP4 360p H.264 3D';;
    84) echo 'MP4 720p H.264 3D';;
    100) echo 'WebM 360p VP8 3D';;
    102) echo 'WebM 720p VP8 3D';;
  esac
}

red(){
  printf "\e[1;31m%s\e[m\n" "$1"
}

[ ! $1 ] && echo "Usage: ${0##*/} http://www.youtube.com/..." && exit

# Create array
videos=()
while read; do
  # Raw URL decode
  # (%25 %) (%26 &) (%2F /) (%3A :) (%3D =) (%3F ?)
  printf -v video "%b" "${REPLY//%/\\x}"
  videos+=("$video")
done < <(download "$1" | sed "s.[=\].\n.g" | grep "videoplayback%3F")

# Choose video
for i in "${!videos[@]}"; do
  # Get quality
  video="${videos[i]}"
  printf "%s\t" "$i"
  get_quality "$video"
done

red 'Make choice.'; read
video="${videos[REPLY]}"
echo "$video"
download "$video" > videoplayback
wget -O videoplayback2 "$video"

# HTTP/1.1 302 Found
# Last-Modified: Wed, 02 May 2007 10:26:10 GMT
# Date: Sat, 07 Jul 2012 05:41:29 GMT
# Expires: Sat, 07 Jul 2012 05:41:29 GMT
# Cache-Control: private, max-age=900
# Location: http://o-o.preferred.dfw06s13.v20.nonxt8.c.youtube.com/videoplayback
#   ?upn=NPYbmpCzWXU&sparams=algorithm%2Cburst%2Ccp%2Cfactor%2Cid%2Cip%2Cipbits%
#   2Citag%2Csource%2Cupn%2Cexpire&fexp=918006%2C913602%2C907217%2C907335%2C9216
#   02%2C919306%2C922600%2C919316%2C920704%2C924500%2C924700%2C913542%2C919324%2
#   C920706%2C907344%2C912706%2C902518&mt=1341639544&ms=nxu&algorithm=throttle-f
#   actor&itag=36&ip=76.0.0.0&burst=40&sver=3&signature=8B34EFA6304C9BB2B5582BF7
#   A03B1D3141C55A36.2369CE0C38950EC9BA3AA8DCDC654DBC09EE0A6E&source=youtube&exp
#   ire=1341663243&key=yt1&ipbits=8&factor=1.25&cp=U0hTRlZRUV9JTUNOM19OS1VDOml1a
#   W5iVFk3UVla&id=2c77a5108255c621&redirect_counter=1&cms_redirect=yes
# Connection: close
# X-Content-Type-Options: nosniff
# Content-Type: text/html
# Server: gvs 1.0
