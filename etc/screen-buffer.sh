#!/bin/sh
if [ "$#" != 2 ]
then
  regtool get /user/console/ScreenBufferSize | awk '
  {
    print "screen-buffer.sh ROWS COLUMNS"
    print "max rows is 32767"
    print "max columns is 170"
    print "current buffer rows", rshift($0, 0x0010)
    print "current buffer columns", and($0, 0xFFFF)
  }
  '
  exit
fi

function hx {
  printf 0x%04x%04x $*
}

regtool set /user/console/ScreenBufferSize $(hx $1 $2)
regtool set /user/console/WindowSize       $(hx 22 $2)
cygstart bash
kill -7 $PPID
