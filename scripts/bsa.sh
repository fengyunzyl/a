# Binary search algorithm

warn () {
  printf '\e[36m%s\e[m\n' "$*"
}

if (( $# != 2 ))
then
  echo ${0##*/} LBOUND UBOUND
  exit
fi

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
  select foo in higher lower
  do
    break
  done
  if [ $foo = higher ]
  then
    (( lb = k ))
  else
    (( ub = k ))
  fi
done
