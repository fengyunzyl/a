# Optimize RTMP string

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

log ()
{
  unset PS4
  set $((set -x; : "$@") 2>&1)
  gg=$2
  shift 2
  warn $*
  if [ $gg = 1 ]
  then
    eval exec $*
  else
    echo $* > opt-rtmp.txt
  fi
}

usage ()
{
  echo "Usage:  $0 COMMAND"
  exit
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

clean ()
{
  rm a.flv
}

[ $1 ] || usage

for hh
do
  trim hh
  bb[aa++]=$hh
done

watch ()
{
  : ${KB=1000}
  while read -d $'\r' ccc
  do
    [[ $ccc =~ [0-9]+ ]]
    if (( BASH_REMATCH >= KB ))
    then
      read WINPID </proc/$!/winpid
      /bin/kill -f $WINPID
      echo
      return
    fi
  done < <(log 1 "$@" &> >(tee /dev/tty))
  return 1
}

for ((hh = 1; hh < aa; hh++))
do
  one=${bb[hh]}
  unset bb[hh]
  two=${bb[hh+1]}
  [[ $two =~ ^- ]] && unset two || unset bb[hh+1]
  if ! watch ${bb[@]} -o a.flv -m 9
  then
    bb[hh]=$one
    bb[hh+1]=$two
  fi
  [[ $two ]] && (( hh++ ))
done

qsplit ()
{
  IFS='&?' read -a $1 <<< "${!2}"
}

qjoin ()
{
  set $*[*]
  IFS='&' read $1 <<< "${!2}"
}

for hh in ${!bb[@]}
do
  # Break up querystring, if it exists
  IFS=? read url qs <<< "${bb[hh]}"
  qsplit qa qs
  for ff in ${!qa[@]}
  do
    one=${qa[ff]}
    unset qa[ff]
    qjoin qs qa
    bb[hh]=${url}${qs:+?$qs}
    if ! watch ${bb[@]} -o a.flv -m 9
    then
      qa[ff]=$one
    fi
  done
  qjoin qs qa
  bb[hh]=${url}${qs:+?$qs}
done

log 2 ${bb[*]} -o a.flv
clean
