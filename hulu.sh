#!/bin/bash
p="plugin-container.exe"

pid(){
  ps -W | grep "$1" | cut -c-9
}

attrget(){
  : "${1#*$2=\"}" # Remove front
  echo "${_%%\"*}" # Remove back
}

red(){
  printf "\e[1;31m%s\e[m\n" "$1"
}

# Kill flash player
pid "$p" | xargs /bin/kill -f
# Disable protected mode, 32 and 64 bit Windows
printf "ProtectedMode=0" > "${COMSPEC%\\*}/Macromed/Flash/mms.cfg"
red 'Press enter after video starts'; read
red 'Printing results'
# Dump flash player
pid "$p" | xargs dumper p &
sleep 1

# Create array
while read -d $'\0'; do
  videos+=("$REPLY")
done < <(grep -az "video server" p.core)

# Choose video
for i in "${!videos[@]}"; do
  video="${videos[i]}"
  read file_type < <(attrget "$video" "file-type")
  read cdn < <(attrget "$video" "cdn")
  printf "%2d\t%9s\t%s\n" "$i" "$file_type" "$cdn"
done

red 'Make choice. Avoid level3.'; read
video="${videos[REPLY]}"
read server < <(attrget "$video" "server")
read stream < <(attrget "$video" "stream")
read token < <(attrget "$video" "token")
app="${server#*//*/}"

set -x
rtmpdump \
-W "http://download.hulu.com/huludesktop.swf" \
-a "$app?${token//&amp;/&}" \
-o "out.flv" \
-r "$server" \
-y "$stream"
