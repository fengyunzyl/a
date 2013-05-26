# get RTMP port

quiet ()
{
  $* &>/dev/null
}

usage ()
{
  echo usage: $0 URL
  exit
}

PATH=/bin:${TMP%U*}progra~2/mozill~1
hash firefox || exit
[ $1 ] || usage
arg_url=$1
cd $WINDIR/system32/macromed/flash

if [ -w . ]
then
  echo ProtectedMode=0 > mms.cfg
else
  echo you must be an administrator
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
echo starting firefox
MOZ_DISABLE_OOP_PLUGINS=1 firefox -no-remote -profile . $arg_url &
PID=$!
: ${S1=20}
echo dump will start in $S1 seconds
sleep $S1
echo dumping firefox
read WINPID </proc/$PID/winpid
quiet dumper port $WINPID &
: ${S2=4}
echo dump will stop in $S2 seconds
sleep $S2
echo killing firefox
kill -13 $PID
wait $PID
echo searching dump file
egrep -ao '[a-zA-Z]+://[-0-9A-Za-z]+\.[-.:0-9A-Za-z]+' port.core | sort -u
