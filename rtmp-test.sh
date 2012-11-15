#!/bin/bash
# Tests for RtmpDump

pgrep()
{
  ps -W | awk /$1/'{print$4;exit}'
}

pkill()
{
  pgrep $1 | xargs kill -f
}

warn()
{
  echo -e "\e[1;35m$1\e[m"
}

dump()
{
  palemoon $1
  pc=plugin-container
  pkill $pc
  pkill rtmpdumphelper
  echo ProtectedMode=0 2>/dev/null >$WINDIR/system32/macromed/flash/mms.cfg
  warn 'Killed flash player for clean dump.'
  warn 'Press enter after video starts, or s to skip.'
  read
  [ "$REPLY" = s ] && return
  
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

  warn 'Press enter to start RtmpDumpHelper, then restart video.'
  read

  LANG= grep -Eaom1 '(RTMP|rtmp).{0,2}://[-.0-z]+' pg.core |
    cut -d: -f3 > tp

  read < tp
  cg=/usr/local/bin/rtmpdumphelper.cfg
  echo "[general]" > $cg
  echo "autorunproxyserver=0" >> $cg
  echo "captureportslist=1935 $REPLY" >> $cg
  echo "usecaptureportslist=1" >> $cg
  rtmpdumphelper &
  read -r rp < <(rtmpsrv -i)
  pkill rtmpdumphelper

  tr "[:cntrl:]" "\n" < pg.core |
    grep -1m1 secureTokenResponse |
    tac > tp

  read < tp
  rm pg.core tp
  eval "$rp -T '$REPLY' -B 10"
}

urls=(
  http://cwtv.com/cw-video/the-next
  http://de.twitch.tv
  http://viki.com/channels/5453-killer-k/videos/51483
  http://tape.tv
  http://tvpublica.com.ar/vivo
  http://canaldosconcursos.com.br/video_demo.php?id_cursos=3130
  http://zonytvcom.info
)

for url in ${urls[@]}
  do
    dump $url
  done
