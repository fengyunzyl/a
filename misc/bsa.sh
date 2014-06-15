# Binary search algorithm
warn () {
  printf '\e[36m%s\e[m\n' "$*"
}

if (( $# != 2 ))
then
  echo ${0##*/} GOOD BAD
  exit
fi

gb=$1
bb=$2

while :
do
  (( ty = (gb + bb) / 2 ))
  if (( sg[ty]++ ))
  then
    break
  fi
  warn $ty
  select co in good bad
  do
    break
  done
  if [ $co = good ]
  then
    (( gb = ty ))
  else
    (( bb = ty ))
  fi
done
