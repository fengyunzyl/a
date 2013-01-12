#!/bin/bash

quote ()
{
  [[ ${!1} =~ [\ \&] ]] && read $1 <<< \"${!1}\"
}

warn ()
{
  printf "\e[36m%s\e[m\n" "$*"
}

pgrep ()
{
  ps -W | awk /$1/'{print$4;exit}'
}

pkill ()
{
  pgrep $1 | xargs kill -f
}

log ()
{
  local pp
  for oo
  do
    quote oo
    pp+=("$oo")
  done
  warn "${pp[@]}"
  eval "${pp[@]}"
}

rsplit ()
{
  IFS=$3 read -a $1 <<< "${!2}"
}

usage ()
{
  echo "Usage:  $0 DELAY TITLE"
  exit
}

[ $1 ] || usage
pc=plugin-container
pkill $pc
echo ProtectedMode=0 2>/dev/null >$WINDIR/system32/macromed/flash/mms.cfg
warn 'Killed flash player for clean dump.
Script will automatically continue after video is restarted.'

until read < <(pgrep $pc)
do
  sleep 1
done

sleep $1
shift
rm -f pg.core
dumper pg $REPLY &

until [ -s pg.core ]
do
  sleep 1
done

kill -13 %%
mapfile vids < <(grep -aoz "<video [^>]*>" pg.core | sort | uniq -w123)

i=0
for vs in "${vids[@]}"
do
  rsplit va vs \"
  j=0
  while [[ "${va[j]}" =~ \ ([^=]*) ]]
  do
    read ${BASH_REMATCH[1]//[-:]}[i] <<< "${va[j+1]}"
    ((j+=2))
  done
  printf "%2d\t%9s\t%s\n" "$i" "${filetype[i]}" "${cdn[i]}"
  ((i++))
done

warn 'Make choice. Avoid level3.'
read rp
rm pg.core
log rtmpdump \
  -o a.flv \
  -W http://download.hulu.com/huludesktop.swf \
  -r "${server[rp]}" \
  -y "${stream[rp]}" \
  -a "${server[rp]#*//*/}?${token[rp]//amp;}"
log ffmpeg -i a.flv -c copy -v warning "$*.mp4"
rm a.flv
