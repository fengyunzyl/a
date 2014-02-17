# get/set size of the terminal

usage () {
  echo ${0##*/} ROWS COLUMNS
  set $(powershell '(gp hkcu:console)'.ScreenBufferSize)
  echo current buffer rows $(( $1 >> 16 ))
  echo current buffer columns $(( $1 & 0xffff ))
  exit
}

(( $# )) || usage
# convert to hex
set $(printf '%04x ' $1 $2 25)
powershell "
sp hkcu:console ScreenBufferSize 0x${1}${2}
sp hkcu:console WindowSize 0x${3}${2}
saps bash
"
kill -7 $PPID
