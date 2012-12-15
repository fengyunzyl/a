#!/bin/bash
# Optimize RTMP string

warn ()
{
  echo -e "\e[1;35m$@\e[m"
}

log ()
{
  warn "$@"
  eval "$@"
}

usage ()
{
  warn "Usage:  ${0##*/} COMMAND"
  exit
}

quote ()
{
  [[ ${!1} =~ [\ \&] ]] && read $1 <<< \"${!1}\"
}

unquote ()
{
  read $1 <<< "${!1//\"}"
}

trim ()
{
  # Dont remove trailing slash, it will mess up "app" parsing
  # Dont remove ".mp4", some servers require it
  # Dont lowercase because app querystring is case sensitive
  read $1 <<< ${!1/\/\/www.///}
  read $1 <<< ${!1/:1935\///}
}

[ $1 ] || usage
shift

for ac
do
  [[ $ac =~ ^- ]] && trim ac && quote ac
  ab[aa++]=$ac
done

for ((ac = 0; ac < aa; ac++))
do
  one=${ab[ac]}
  unset ab[ac]
  two=${ab[ac+1]}
  [[ $two =~ ^- ]] && unset two || unset ab[ac+1]
  log rtmpdump ${ab[@]} -B .1 -o a.flv
  # Partial download will return 2, which is ok
  [ $? = 1 ] && ab[ac]=$one && [ $two ] && ab[++ac]=$two
done

qsplit ()
{
  IFS=\& read -a $1 <<< "${!2}"
}

qjoin ()
{
  IFS=\& read $1 < <(eval echo \"\${$2[*]}\")
}

for ac in ${!ab[@]}
do
  # Break up querystring, if it exists
  if [[ ${ab[ac]} =~ \? ]]
  then
    unquote ab[ac]
    IFS=? read url qs <<< "${ab[ac]}"
    qsplit qa qs
    for ae in ${!qa[@]}
    do
      b1=${ab[ac]}
      b2=${qa[ae]}
      ab[ac]="$url"
      unset qa[ae]
      qjoin qs qa
      [ $qs ] && ab[ac]+="?$qs"
      quote ab[ac]
      log rtmpdump ${ab[@]} -B .1 -o a.flv
      [ $? = 1 ] && ab[ac]=$b1 && qa[ae]=$b2
    done
  fi
done

rm a.flv
warn rtmpdump ${ab[@]} -o a.flv
echo rtmpdump ${ab[@]} -o a.flv > a.sh
