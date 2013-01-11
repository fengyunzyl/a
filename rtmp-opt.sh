#!/bin/bash
# Optimize RTMP string

warn ()
{
  printf "\e[36m%s\e[m\n" "$*"
}

log ()
{
  warn "$@"
  eval exec "$@"
}

usage ()
{
  echo "Usage:  $0 COMMAND"
  exit
}

quote ()
{
  [[ ${!1} =~ [\ \#\&\;] ]] && read $1 <<< \"${!1}\"
}

unquote ()
{
  read $1 <<< "${!1//\"}"
}

trim ()
{
  # Dont lowercase because app querystring is case sensitive
  # Dont remove ".mp4" "mp4:" or "www.", some servers require it
  # Dont remove trailing slash, it will mess up "app" parsing
  # Dont decode the URL, some servers require encoded URL
  read $1 <<< "${!1//amp;}"
  read $1 <<< "${!1/:1935\///}"
}

[ $1 ] || usage

for hh
do
  trim hh
  quote hh
  bb[aa++]=$hh
done

watch ()
{
  while [ -d /proc/$2 ]
  do
    sleep 1
    read < <(tr '\r' '\n' < $1 | tac | cut -d. -f1)
    if (( $REPLY + 1 > $3 ))
    then
      kill -13 $2
      > $1
      echo
    fi
  done
}

for ((hh = 1; hh < aa; hh++))
do
  one=${bb[hh]}
  unset bb[hh]
  two=${bb[hh+1]}
  [[ $two =~ ^- ]] && unset two || unset bb[hh+1]
  log ${bb[@]} -o a.flv -m 9 2> >(tee kk) &
  watch kk $! 1000
  [ -s kk ] && bb[hh]=$one
  [[ $two ]] || continue
  (( hh++ ))
  [ -s kk ] && bb[hh]=$two
done

qsplit ()
{
  IFS=\&? read -a $1 <<< "${!2}"
}

qjoin ()
{
  IFS=\& read $1 < <(eval echo \"\${$2[*]}\")
}

for hh in ${!bb[@]}
do
  # Break up querystring, if it exists
  unquote bb[hh]
  IFS=? read url qs <<< "${bb[hh]}"
  qsplit qa qs
  for ff in ${!qa[@]}
  do
    one=${qa[ff]}
    unset qa[ff]
    qjoin qs qa
    bb[hh]=${url}${qs:+?$qs}
    quote bb[hh]
    log ${bb[@]} -o a.flv -m 9 2> >(tee kk) &
    watch kk $! 1000
    [ -s kk ] && qa[ff]=$one
  done
  qjoin qs qa
  bb[hh]=${url}${qs:+?$qs}
  quote bb[hh]
done

fd ()
{
  [ -a kk ] || exit
  printf '\n\n'
  fold -w69 kk
  rm a.flv kk &
  wait $!
}

trap fd 0 2
echo ${bb[@]} -o a.flv > kk
eval ${bb[@]} -o a.flv |& tee -a kk
