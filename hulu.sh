#!/bin/bash

quote ()
{
  [[ ${!1} =~ [\ \&] ]] && read $1 <<< \"${!1}\"
}

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
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
    pp+=($oo)
  done
  echo ${pp[*]} >> a.txt
  warn ${pp[*]}
  eval ${pp[*]}
}

bsplit ()
{
  IFS=\" read -a $1 <<< "${!2}"
}

usage ()
{
  echo "usage: $0 DELAY CDN FILETYPE TITLE"
  echo
  echo "To see available CDNs and filetypes run script with just DELAY."
  exit
}

clean ()
{
  rm -f a.core a.flv a.txt
}

serialize ()
{
  xs=${!1}
  xs=${xs#* }
  xs=${xs%/>}
  bsplit xa xs
  aa=0
  while [ ${xa[aa]} ]
  do
    read ${xa[aa]//[-:=]} <<< ${xa[aa+1]}
    (( aa += 2 ))
  done
}

coredump ()
{
  pkill $2
  warn Killed $2 for clean dump.
  warn Script will automatically continue after $2 is restarted.
  until read < <(pgrep $2)
  do
    sleep 1
  done
  sleep $1
  clean
  dumper a $REPLY &
  until [ -s a.core ]
  do
    sleep 1
  done
  kill -13 %%
}

[ $1 ] || usage
echo ProtectedMode=0 2>/dev/null >$WINDIR/system32/macromed/flash/mms.cfg
coredump $1 plugin-container
shift

while read video
do
  serialize video
  if ! [ $1 ]
  then
    printf '%-9s  %9s\n' $cdn $filetype
  elif [ $cdn$filetype = $1$2 ]
  then
    break
  fi
done < <(grep -ao '<video [^>]*>' a.core | sort | uniq -w123)

if ! [ $1 ]
then
  clean
  exit
fi

log rtmpdump \
  -o a.flv \
  -W http://download.hulu.com/huludesktop.swf \
  -r $server \
  -y $stream \
  -a ${server#*//*/}?${token//amp;}

shift 2
log ffmpeg -i a.flv -c copy -v warning "$*.mp4"
clean
