#!/bin/bash
PATH+=":."
p="plugin-container.exe"
red="\e[1;31m%s\e[m\n"

pid(){
  ps -W | grep "$1" | cut -c-9
}

attrget(){
  s="$1"
  s="${s#*$2=\"}" # Remove front
  s="${s%%\"*}" # Remove back
  printf "$s"
}

# Kill flash player
pid "$p" | xargs /bin/kill -f
# Disable protected mode, 32 and 64 bit Windows
printf "ProtectedMode=0" > "$(cygpath -S)/Macromed/Flash/mms.cfg"
printf $red 'Press enter after video starts'; read
printf $red 'Printing results'
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
  file_type=$(attrget "$video" "file-type")
  cdn=$(attrget "$video" "cdn")
  printf "%2d\t%9s\t%s\n" "$i" "$file_type" "$cdn"
done

printf $red 'Make choice. Avoid level3.'; read
video="${videos[REPLY]}"
server=$(attrget "$video" "server")
stream=$(attrget "$video" "stream")
token=$(attrget "$video" "token")
app="${server#*//*/}"

set -x
rtmpdump \
-W "http://download.hulu.com/huludesktop.swf" \
-a "$app?${token//&amp;/&}" \
-o "out.flv" \
-r "$server" \
-y "$stream"
