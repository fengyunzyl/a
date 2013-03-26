#!/bin/bash

if [[ $OSTYPE =~ linux ]]
then
  FIREFOX=firefox
else
  FIREFOX="$PROGRAMFILES/mozilla firefox/firefox"
fi

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

log ()
{
  unset PS4
  coproc yy (set -x; : "$@") 2>&1
  read -r zz <&$yy
  warn ${zz:2}
  "$@"
}

usage ()
{
  echo "usage: $0 [CDN FILETYPE] URL"
  echo
  echo "CDN       content delivery network"
  echo "FILETYPE  quality"
  echo
  echo "run with just URL to get CDN and FILETYPE params"
  exit
}

serialize_xml ()
{
  set "${!1/<}"
  eval set ${1/>}
  for oo
  do
    set ${oo/=/ }
    read ${1/[-:]} <<< $2
  done
}

coredump ()
{
  arg_pid=$!
  arg_prog=$1
  echo waiting for $arg_prog to load...
  aaa=90
  set 0 0
  while sleep 1
  do
    mapfile bbb </proc/$arg_pid/maps
    (( ccc = ${2} - ${1} ))
    (( ddd = ${#bbb[*]} - ${2} ))
    if (( ${ccc/-} + ${ddd/-} < aaa ))
    then
      break
    fi
    set ${2} ${#bbb[*]}
  done
  echo dumping $arg_prog...
  read WINPID </proc/$arg_pid/winpid
  dumper hulu $WINPID 2>&- &
  until [ -s hulu.core ]
  do
    sleep 1
  done
  kill -13 $arg_pid
}

download ()
{
  IFS=/ read gg hh <<< "$2"
  exec 3< /dev/tcp/$gg/80
  {
    echo GET /$hh HTTP/1.1
    echo connection: close
    echo host: $gg
    echo
  } >&3
  sed '1,/^$/d' <&3 > $1
}

[ $1 ] || usage
[ $3 ] || set '' '' $1
arg_cdn=$1
arg_filetype=$2
arg_url=$3
arg_pwd=$PWD
cd $WINDIR
echo ProtectedMode=0 > system32/macromed/flash/mms.cfg
rm -r /tmp
mkdir /tmp
cd "$APPDATA/mozilla/firefox"
read aa < <(find -name cookies.sqlite -exec ls -t {} +)
cp "$aa" /tmp
read aa < <(find -name prefs.js -exec ls -t {} +)
cp "$aa" /tmp
cd /tmp
MOZ_DISABLE_OOP_PLUGINS=1 "$FIREFOX" -no-remote -profile . $arg_url &
coredump firefox
grep -ao '<video [[:print:]]*>' hulu.core | sort | uniq -w123 > hulu.smil

if ! [ -s hulu.smil ]
then
  warn dumped too soon, retry
  echo $aaa $ccc $ddd
  exit
fi

while read video
do
  serialize_xml video
  if ! [ $arg_cdn ]
  then
    printf '%-9s  %9s\n' $cdn $filetype
  elif [ $cdn$filetype = $arg_cdn$arg_filetype ]
  then
    break
  else
    false
  fi
done < hulu.smil

[ $? = 0 ] || usage
[ $arg_cdn ] || exit
[[ $arg_url =~ [0-9]+ ]]

if [ -a /usr/local/bin/jq ]
then
  download hulu.json "www.hulu.com/api/2.0/video?id=$BASH_REMATCH"
  read uu < <(jq -r .show.name hulu.json)
  read vv < <(jq .season_number hulu.json)
  read ww < <(jq .episode_number hulu.json)
  read xx < <(jq -r .title hulu.json)
  flv="${uu} ${vv}x${ww} ${xx}"
else
  flv="$BASH_REMATCH"
fi

cd "$arg_pwd"
app="${server#*//*/}?${token//amp;}"

log rtmpdump \
  -W http://download.hulu.com/huludesktop.swf \
  -r $server \
  -a $app \
  -y $stream \
  -o "$flv.flv"

if [ -a /usr/local/bin/ffmpeg ]
then
  log ffmpeg -i "$flv.flv" -c copy -v warning "$flv.mp4"
  log rm "$flv.flv"
fi
