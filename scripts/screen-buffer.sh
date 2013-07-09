# get/set size of the terminal

usage ()
{
  echo usage: $0 ROWS COLUMNS
  set $(reg query 'hkcu\console' | grep ScreenBufferSize)
  echo current buffer rows $(( $3 >> 16 ))
  echo current buffer columns $(( $3 & 0xffff ))
  exit
}

[ $1 ] || usage
# convert to hex
set $(printf '%04x ' $1 $2 25)
reg add 'hkcu\console' -f -t reg_dword -v ScreenBufferSize -d 0x$1$2
reg add 'hkcu\console' -f -t reg_dword -v WindowSize -d 0x$3$2
cygstart bash -l
kill -7 $PPID
