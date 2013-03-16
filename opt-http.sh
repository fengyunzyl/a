
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
  coproc yy (set -x; : "$@") 2>&1
  read zz <&$yy
  warn ${zz:2}
  exec "$@"
}

[ $2 ] || usage
arg_search=$1
shift

for hh
do
  if ! [ "$hh" = "-O" ]
  then
    bb[aa++]=$hh
  fi
done


for ((hh = 1; hh < aa; hh++))
do
  one=${bb[hh]}
  unset bb[hh]
  two=${bb[hh+1]}
  [[ $two =~ ^- ]] && unset two || unset bb[hh+1]
  if ! log "${bb[@]}" -s | grep --color $arg_search
  then
    bb[hh]=$one
    bb[hh+1]=$two
  fi
  [[ $two ]] && (( hh++ ))
done

for hh in ${!bb[@]}
do
  # break up cookies
  IFS=':' read name vs <<< "${bb[hh]}"
  bsplit va vs
  for ff in ${!va[@]}
  do
    one=${va[ff]}
    unset va[ff]
    bjoin vs va
    bb[hh]=${name}${vs:+:$vs}
    if ! log "${bb[@]}" -s | grep --color $arg_search
    then
      echo FAIL
      va[ff]=$one
    fi
  done
  bjoin vs va
  bb[hh]=${name}${vs:+:$vs}
done

coproc yy (set -x; : "${bb[@]}") 2>&1
cut -b6- <&$yy
