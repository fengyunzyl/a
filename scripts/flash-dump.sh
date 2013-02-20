#!/bin/sh

firefox ()
{
  exec "$PROGRAMFILES/mozilla firefox/firefox" $*
}

coredump ()
{
  PID=$!
  echo waiting for $1 to load...
  rr=()
  until (( ${#rr[*]} > 1700 ))
  do
    mapfile rr </proc/$PID/maps
    sleep 1
  done
  echo dumping $1...
  read WINPID </proc/$PID/winpid
  dumper ff $WINPID 2>&- &
  until [ -s ff.core ]
  do
    sleep 1
  done
  kill -13 $PID
}

arg_pwd=$PWD
cd $WINDIR
echo ProtectedMode=0 > system32/macromed/flash/mms.cfg
rm -r /tmp
mkdir /tmp
cd /tmp
MOZ_DISABLE_OOP_PLUGINS=1 firefox -no-remote -profile . &
cd $arg_pwd
rm -f ff.core
coredump firefox
