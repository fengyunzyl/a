# download from Hulu

warn () {
  printf '\e[36m%s\e[m\n' "$*"
}

log () {
  unset PS4
  qq=$(( set -x
         : "$@" ) 2>&1)
  warn "${qq:2}"
  eval "${qq:2}"
}

usage () {
  echo "USAGE"
  echo "  ${0##*/} [CDN TYPE] URL"
  echo "  run with just URL to get CDN and TYPE params"
  echo "CDN"
  echo "  content delivery network"
  echo "TYPE"
  echo "  quality"
  exit
}

case $# in
     1) set '' '' $1 ;;
  [02]) usage        ;;
esac

arg_cdn=$1
arg_type=$2
arg_url=$3
arg_pwd=$PWD
mount -f "$PROGRAMFILES" /programfiles
PATH='/bin:/usr/local/bin:/programfiles/mozilla firefox'
type firefox >/dev/null || exit
cd $WINDIR/system32/macromed/flash

if [ -w . ]
then
  echo ProtectedMode=0 > mms.cfg
else
  warn you must be an administrator
  exit
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
echo waiting for firefox to load...
: ${S1=20}
sleep $S1
echo dumping firefox...
read WINPID </proc/$PID/winpid
dumper hulu $WINPID &
: ${S2=4}
sleep $S2
kill -13 $PID
wait $PID
grep -ao '<video [[:print:]]*/>' hulu.core | sort | uniq -w123 > hulu.smil

if ! [ -s hulu.smil ]
then
  warn Dumped too soon, try increasing sleep values.
  warn Example using current values
  warn S1=$S1 S2=$S2 ${0##*/} URL
  exit
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
flv=$BASH_REMATCH
cd "$arg_pwd"
app=${server#*//*/}?${token//amp;}

log rtmpdump \
  -W http://download.hulu.com/huludesktop.swf \
  -r $server \
  -a $app \
  -y $stream \
  -o "$flv.flv"

(( $? )) && exit

if type ffmpeg
then
  log ffmpeg -i "$flv.flv" -c copy -v warning "$flv.mp4"
  log rm "$flv.flv"
fi
