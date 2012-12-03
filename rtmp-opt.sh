#!/bin/sh
# Optimize RTMP string

warn ()
{
  echo -e "\e[1;35m$@\e[m"
}

try ()
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
  # add double quotes if needed
  [[ ${!1} =~ \& ]] && read $1 <<< \"${!1}\"
}

unquote ()
{
  read $1 <<< ${!1//\"}
}

trim ()
{
  read $1 <<< ${!1/\/\/www.///}
  read $1 <<< ${!1/:1935\///}
}

[ $1 ] || usage
shift

aa=0
for ac
do
  trim ac
  quote ac
  ab[aa]=$ac
  (( aa++ ))
done

for ac in ${!ab[@]}
do
  read b1 <<< ${ab[ac]}
  unset ab[ac]
  ! try rtmpdump -o a.flv -B .1 ${ab[@]} && ab[ac]=$b1
done

for ac in ${!ab[@]}
do
  # Break up querystring, if it exists
  if [[ ${ab[ac]} =~ \? ]]
    then
      unquote ab[ac]
      url="${ab[ac]%\?*}"
      # split
      IFS=\& read -a qs <<< "${ab[ac]#*\?}"
      for ae in ${!qs[@]}
      do
        # if command fails on last section of qs you will need to restore ab
        # if command fails before last section of qs you will need to restore qs
        read b1 <<< ${ab[ac]}
        read b2 <<< ${qs[ae]}
        unset qs[ae]
        # join
        IFS=\& read ab[ac] <<< "$url?${qs[*]}"
        quote ab[ac]
        ! try rtmpdump -o a.flv -B .1 ${ab[@]} && ab[ac]=$b1 && qs[ae]=$b2
      done
  fi
done

warn rtmpdump -o a.flv ${ab[@]}
