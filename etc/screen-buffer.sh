#!/bin/dash -e
if [ "$#" != 2 ]
then
  ju=$(reg query 'hkcu\console' /v screenBufferSize | awk '$0=$3')
  cat <<+
screen-buffer.sh [rows] [columns]
max rows is 32767
max columns is 170
current buffer rows $((ju >> 0x0010))
current buffer columns $((ju & 0xFFFF))
+
  exit
fi
ki=$1
li=$2

mi() {
  printf '0x%04x%04x' "$@"
}

reg add 'hkcu\console' /f /v screenBufferSize /t reg_dword \
  /d "$(mi "$ki" "$li")"
reg add 'hkcu\console' /f /v windowSize /t reg_dword \
  /d "$(mi 22 "$li")"
echo 'you must close shell to apply changes'
