#!/bin/bash
# Optimize RTMP string

warn ()
{
  printf "\e[1;35m%s\e[m\n" "$*"
}

log ()
{
  warn "$@"
  eval exec "$@"
}

usage ()
{
  warn "Usage:  ${0##*/} COMMAND"
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
  # Dont remove ".mp4" "mp4:" or "www.", some server require it
  # Dont remove trailing slash, it will mess up "app" parsing
  printf -v $1 %b "${!1//\%/\x}"
  printf -v $1 %s "${!1//amp;}"
  printf -v $1 %s "${!1/:1935\///}"
}

[ $1 ] || usage

for hh
do
  trim hh
  quote hh
  bb[aa++]=$hh
done

grepkill ()
{
  # search stderr, then kill
  while [ -d /proc/$! ]
  do
    if grep -q "$1" $2
    then
      kill %%
      > $2
      echo
    fi
    sleep 1
  done 2>/dev/null
}

for ((hh = 1; hh < aa; hh++))
do
  one=${bb[hh]}
  unset bb[hh]
  two=${bb[hh+1]}
  [[ $two =~ ^- ]] && unset two || unset bb[hh+1]
  log ${bb[@]} -o a.flv -m 9 -\# 2> >(tee kk) &
  grepkill '######' kk
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
    log ${bb[@]} -o a.flv -m 9 -\# 2> >(tee kk) &
    grepkill '######' kk
    [ -s kk ] && qa[ff]=$one
  done
  qjoin qs qa
  bb[hh]=${url}${qs:+?$qs}
  quote bb[hh]
done

fd ()
{
  printf '\n\n'
  fold -w69 kk
  rm a.flv kk
}

trap fd 0 INT
echo ${bb[@]} -o a.flv > kk
eval ${bb[@]} -o a.flv |& tee -a kk
