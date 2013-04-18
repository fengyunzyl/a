
usage ()
{
  echo usage: $0 SEARCH COMMAND
  exit
}

bsplit()
{
  IFS=';' read -a $1 <<< "${!2}"
}

bjoin()
{
  IFS=';' read $1 < <(eval echo \"\${$2[*]}\")
}

warn ()
{
  printf '\e[36m%s\e[m\n' "$*" >&2
}

log ()
{
  unset PS4
  set $((set -x; : "$@") 2>&1)
  shift
  warn $*
  eval $*
}

[[ $1 ]] || usage
[[ $1 = curl ]] && usage

for hh
do
  bb[aa++]=$hh
done

arg_search=$bb
unset bb[0]
unset bb[1]

for hh in ${!bb[*]}
do
  if [[ ${bb[hh]} = -o ]]
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
  if log curl "${bb[@]}" "$arg_url" | grep --color -m1 "$arg_search"
  then
    # restore if download failed
    bb[hh]=$one
    bb[hh+1]=$two
  fi
  [[ $two ]] && (( hh++ ))
done
