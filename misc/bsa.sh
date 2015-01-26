# Binary search algorithm
function warn {
  printf '\e[36m%s\e[m\n' "$*"
}

if [ $# != 2 ]
then
  echo bsa.sh GOOD BAD
  exit
fi

gb=$1
bb=$2
echo each iteration will be saved to clipboard

while :
do
  (( ty = (gb + bb) / 2 ))
  if (( sg[ty]++ ))
  then
    break
  fi
  warn $ty
  printf $ty > /dev/clipboard
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
