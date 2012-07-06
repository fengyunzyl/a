#!/bin/sh
# Bash download from YouTube
# stream-recorder.com/forum/why-youtube-delivering-files-2mb-size-instead-t12117.html
# youtube.com/watch?v=LHelEIJVxiE

[ ! $1 ] && echo "Usage: ${0##*/} URL" && exit

host="m.youtube.com"
exec 3<>/dev/tcp/$host/80

headers=(
  "GET ${1#*youtube.com} HTTP/1.1"
  "Connection: close"
  "Host: $host"
  "User-Agent: iPad"
  ""
)

printf "%s\r\n" "${headers[@]}" >&3
cat > index.htm <&3
sed 's.\\".\n.g' index.htm | grep videoplayback
