#!/bin/bash

quote ()
{
  [[ ${!1} =~ [\ \&] ]] && read $1 <<< \"${!1}\"
}

warn ()
{
  echo -e "\e[1;35m$@\e[m"
}

pgrep ()
{
  ps -W | awk /$1/'{print$4;exit}'
}

pkill ()
{
  pgrep $1 | xargs kill -f
}

log ()
{
  local gh
  for gg
  do
    quote gg
    gh+=("$gg")
  done
  warn "${gh[@]}"
  eval "${gh[@]}"
}

rsplit ()
{
  IFS=$3 read -a $1 <<< "${!2}"
}

pc=plugin-container
pkill $pc
echo ProtectedMode=0 2>/dev/null >$WINDIR/system32/macromed/flash/mms.cfg
warn 'Killed flash player for clean dump.
Restart video then press enter here.'
read

until read < <(pgrep $pc)
do
  warn "$pc not found!"
  read
done

rm -f pg.core
dumper pg $REPLY &

until [ -s pg.core ]
do
  sleep 1
done

kill %%
mapfile vids < <(grep -aoz "<video [^>]*>" pg.core | sort | uniq -w123)

i=0
for vs in "${vids[@]}"
do
  rsplit va vs \"
  j=0
  while [[ "${va[j]}" =~ \ ([^=]*) ]]
  do
    read ${BASH_REMATCH[1]//[-:]}[i] <<< "${va[j+1]}"
    ((j+=2))
  done
  printf "%2d\t%9s\t%s\n" "$i" "${filetype[i]}" "${cdn[i]}"
  ((i++))
done

warn 'Make choice. Avoid level3.'
read rp
rm pg.core

log rtmpdump \
  -o a.flv \
  -W http://download.hulu.com/huludesktop.swf \
  -r "${server[rp]}" \
  -y "${stream[rp]}" \
  -a "${server[rp]#*//*/}?${token[rp]//amp;}"
