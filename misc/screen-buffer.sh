if (( $# != 2 ))
then
  echo ${0##*/} ROWS COLUMNS
  echo max columns is 184
  powershell '
  $0 = (gp hkcu:console).ScreenBufferSize
  "current buffer rows {0}" -f ($0 -shr 16)
  "current buffer columns {0}" -f ($0 -band 0xffff)
  '
  exit
fi

powershell '&{
param($rw,$cm)
sp hkcu:console ScreenBufferSize ("0x{0:x}{1:x4}" -f $rw,$cm)
sp hkcu:console WindowSize       ("0x{0:x}{1:x4}" -f  25,$cm)
}' $*

cygstart bash
kill -7 $PPID
