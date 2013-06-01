
usage ()
{
  echo "usage: $0 <fail string> <command>"
  exit
}

bsplit()
{
  IFS=';' read -a $1 <<< "${!2}"
}

bjoin()
{
  set $*[*]
  IFS=';' read $1 <<< "${!2}"
}

warn ()
{
  printf '\e[36m%s\e[m\n' "$*" >&2
}

log ()
{
  unset PS4
  qq=$((set -x; : "$@") 2>&1)
  warn "${qq:2}"
  eval "${qq:2}"
}

[[ $1 ]] || usage
[[ $1 = curl ]] && usage

for hh
do
  bb[aa++]=$hh
done

arg_fail=$bb
unset bb[0]
unset bb[1]

for hh in ${!bb[*]}
do
  if [[ ${bb[hh]} =~ -[Oo] ]]
  then
    arg_url=${bb[hh-1]}
    unset bb[hh-1]
    unset bb[hh]
    unset bb[hh+1]
  fi
done

for ((hh = 0; hh < aa; hh++))
do
  one=${bb[hh]}
  unset bb[hh]
  two=${bb[hh+1]}
  [[ $two =~ ^- ]] && unset two || unset bb[hh+1]
  if log curl -L --compressed "${bb[@]}" "$arg_url" |
    grep --color -m1 "$arg_fail"
  then
    # restore if download failed
    bb[hh]=$one
    bb[hh+1]=$two
  fi
  [[ $two ]] && (( hh++ ))
done

for hh in ${!bb[*]}
do
  # break up cookies
  IFS=':' read name vs <<< "${bb[hh]}"
  bsplit va vs
  for ff in ${!va[*]}
  do
    one=${va[ff]}
    unset va[ff]
    bjoin vs va
    bb[hh]=${name}${vs:+:$vs}
    if log curl -L --compressed "${bb[@]}" "$arg_url" |
      grep --color -m1 "$arg_fail"
    then
      echo FAIL
      va[ff]=$one
    fi
  done
  bjoin vs va
  bb[hh]=${name}${vs:+:$vs}
done
