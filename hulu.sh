# download from Hulu

if [[ $OSTYPE =~ linux ]]
then
  JQ ()
  {
    jq -r "$@" hulu.json
  }
else
  JQ ()
  {
    jq -r "$@" hulu.json | d2u
  }
fi

debug ()
{
  echo $(date +%T.%N | cut -b-11) $* >> /tmp/hulu.log
}

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
  debug $*
}

log ()
{
  unset PS4
  qq=$((set -x; : "$@") 2>&1)
  warn "${qq:2}"
  eval "${qq:2}"
}

usage ()
{
  echo "USAGE"
  echo "  ${0##*/} [CDN TYPE] URL"
  echo "  run with just URL to get CDN and TYPE params"
  echo "CDN"
  echo "  content delivery network"
  echo "TYPE"
  echo "  quality"
  exit
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

post ()
{
  warn post contents of /tmp/hulu.log to
  warn ffmpeg.zeranoe.com/forum/viewtopic.php?t=1055
  exit
}

quiet ()
{
  $* &>/dev/null
}

PATH=/bin:/usr/local/bin:${TMP%U*}progra~2/mozill~1
hash firefox || exit

case $# in
  [02]) usage ;;
  1) set '' '' $1 ;;
esac

arg_cdn=$1
arg_type=$2
arg_url=$3
arg_pwd=$PWD
cd $WINDIR/system32/macromed/flash

if [ -w . ]
then
  echo ProtectedMode=0 > mms.cfg
else
  warn you must be an administrator
  post
fi

rm -r /tmp
mkdir /tmp
cd "$APPDATA/mozilla/firefox"
set $(find -name cookies.sqlite -exec ls -t {} +)
cp "$1" /tmp
set $(find -name prefs.js -exec ls -t {} +)
cp "$1" /tmp
cd /tmp
MOZ_DISABLE_OOP_PLUGINS=1 firefox -no-remote -profile . $arg_url &
PID=$!
debug firefox started
echo waiting for firefox to load...
: ${S1=20}
sleep $S1
echo dumping firefox...
read WINPID </proc/$PID/winpid
quiet dumper hulu $WINPID &
debug starting dump
: ${S2=4}
sleep $S2
kill -13 $PID
debug waiting for firefox to be killed
wait $PID
debug firefox killed
grep -ao '<video [[:print:]]*/>' hulu.core | sort | uniq -w123 > hulu.smil

if ! [ -s hulu.smil ]
then
  warn Dumped too soon, try increasing sleep values.
  warn Example using current values
  warn S1=$S1 S2=$S2 ${0##*/} URL
  post
fi

while read video
do
  eval $(awk NF=NF FPAT='[^ -:]*="[^"]*"' <<< $video)
  if ! [ $arg_cdn ]
  then
    printf '\e[36m%-9s  %9s\e[m\n' $cdn $type
  elif [ $cdn$type = $arg_cdn$arg_type ]
  then
    break
  else
    false
  fi
done < hulu.smil

# check for bogus CDN
(( $? )) && usage
# check for missing CDN
[ $arg_cdn ] || usage
[[ $arg_url =~ [0-9]+ ]]

if quiet command -v jq
then
  download hulu.json www.hulu.com/api/2.0/video?id=$BASH_REMATCH
  flv=$(JQ '"\(.show.name) \(.season_number)x\(.episode_number) \(.title)"')
else
  flv=$BASH_REMATCH
fi

cd "$arg_pwd"
app=${server#*//*/}?${token//amp;}

log rtmpdump \
  -W http://download.hulu.com/huludesktop.swf \
  -r $server \
  -a $app \
  -y $stream \
  -o "$flv.flv"

(( $? )) && exit

if quiet command -v ffmpeg
then
  log ffmpeg -i "$flv.flv" -c copy -v warning "$flv.mp4"
  log rm "$flv.flv"
fi
