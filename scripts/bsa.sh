# Binary search algorithm

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

usage ()
{
  echo usage: $0 LBOUND UBOUND
  exit
}

[ $1 ] || usage
lb=$1
ub=$2

while :
do
  (( k = (lb + ub) / 2 ))
  if (( k == lb ))
  then
    break
  fi
  warn $k
  select foo in good bad
  do
    break
  done
  if [ $foo = good ]
  then
    (( lb = k ))
  else
    (( ub = k ))
  fi
done
