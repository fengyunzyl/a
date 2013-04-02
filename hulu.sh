# download from Hulu

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

coredump ()
{
  arg_pid=$!
  arg_prog=$1
  echo waiting for $arg_prog to load...
  aaa=20
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

returns ()
{
  printf -v kk "$2"
  [[ $((eval $1) 2>&1) =~ $kk ]]
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
flv=$BASH_REMATCH

if ! returns jq 'command not found'
then
  if returns jq '\r'
  then
    echo Windows Native jq found, need Cygwin jq
    echo http://code.google.com/p/any/downloads
  else
    download hulu.json "www.hulu.com/api/2.0/video?id=${flv}"
    set '"\(.show.name) \(.season_number)x\(.episode_number) \(.title)"'
    flv=$(jq -r "$1" hulu.json)
  fi
fi

cd "$arg_pwd"
app="${server#*//*/}?${token//amp;}"

log rtmpdump \
  -W http://download.hulu.com/huludesktop.swf \
  -r $server \
  -a $app \
  -y $stream \
  -o "$flv.flv"

if ! returns ffmpeg 'command not found'
then
  log ffmpeg -i "$flv.flv" -c copy -v warning "$flv.mp4"
  log rm "$flv.flv"
fi
