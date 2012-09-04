#!/bin/bash
set -o igncr # ignore CR
p="plugin-container.exe"

pidof(){
  ps -W | grep "$1" | cut -c-9
}

attrget(){
  : "${1#*$2=\"}" # Remove front
  echo "${_%%\"*}" # Remove back
}

red(){
  printf "\e[1;31m%s\e[m\n" "$1"
}

pidof $p | xargs /bin/kill -f
echo ProtectedMode=0 > \\windows/system32/macromed/flash/mms.cfg
red 'Press enter after video starts'; read
red 'Printing results'
pidof $p | xargs timeout 1 dumper p

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
