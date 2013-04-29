# download from Hulu

if [[ $OSTYPE =~ linux ]]
then
  FIREFOX=firefox
  JQ ()
  {
    jq -r "$@" hulu.json
  }
else
  FIREFOX="$PROGRAMFILES/mozilla firefox/firefox"
  JQ ()
  {
    jq -r "$@" hulu.json | d2u
  }
fi

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

log ()
{
  unset PS4
  set $((set -x; : "$@") 2>&1)
  shift
  warn $*
  eval $*
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
set $(find -name cookies.sqlite -exec ls -t {} +)
cp "$1" /tmp
set $(find -name prefs.js -exec ls -t {} +)
cp "$1" /tmp
cd /tmp
MOZ_DISABLE_OOP_PLUGINS=1 "$FIREFOX" -no-remote -profile . $arg_url &
PID=$!
echo waiting for firefox to load...

until [ -a cache ]
do
  sleep 1
done

bb=80644

until (( $(stat -c%s cache/_cache_001_) > bb ))
do
  sleep 1
done

echo dumping firefox...
read WINPID </proc/$PID/winpid
dumper hulu $WINPID 2>&- &

until [ -a hulu.core ]
do
  sleep 1
done

until (( $(stat -c%s hulu.core) > 100000000 ))
do
  sleep 1
done

kill -13 $PID
grep -ao '<video [[:print:]]*/>' hulu.core | sort | uniq -w123 > hulu.smil

if ! [ -s hulu.smil ]
then
  warn dumped too soon, post reply at
  warn ffmpeg.zeranoe.com/forum/viewtopic.php?t=1055
  echo error $bb
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
  download hulu.json "www.hulu.com/api/2.0/video?id=${BASH_REMATCH}"
  flv=$(JQ '"\(.show.name) \(.season_number)x\(.episode_number) \(.title)"')
else
  flv=$BASH_REMATCH
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
