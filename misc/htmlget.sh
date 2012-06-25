#!/bin/bash
red="\e[1;31m%s\e[m\n"
url="tetristv.com/zapni.tv.php"

attrget(){
    printf "${1//\" /\n}" | grep "$2" | cut -d "\"" -f2
}

# Create array
while read line; do
    ((i++))
    channels[i]="$line"
done < <(wget -qO- "$url" | iconv -f cp1252 | tr "#" "\n" | grep "EXTINF")

# Choose video
for channel in "${channels[@]}"; do
    ((j++))
    printf "%2d\t%s\n" "$j" "${channel%%<*}"
done

printf $red 'Make choice.'; read
channel="${channels[REPLY]}"
attrget "$channel" "href" | xargs "$PROGRAMFILES/VideoLAN/VLC/vlc"
