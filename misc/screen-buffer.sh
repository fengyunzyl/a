function hr {
  sed '
  1d
  $d
  s/  //
  ' <<< "$1"
}

function hx {
  printf 0x%04x%04x $*
}

if (( $# != 2 ))
then
  set $(regtool get /user/console/ScreenBufferSize)
  hr "
  ${0##*/} ROWS COLUMNS
  max rows is 32767
  max columns is 170
  current buffer rows    $(( $1 >> 0x0010 ))
  current buffer columns $(( $1  & 0xFFFF ))
  "
  exit
fi

regtool set /user/console/ScreenBufferSize $(hx $1 $2)
regtool set /user/console/WindowSize       $(hx 22 $2)
cygstart bash
kill -7 $PPID
