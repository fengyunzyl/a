# Binary search algorithm

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

usage ()
{
  echo usage: $0 torvalds/linux
  exit
}

[ $1 ] || usage

# HTTPS is faster because no redirect
url=https://github.com/$1/commit/HEAD~
((up = 1))

while wget -q --spider $url$up
do
  printf '%d\t' $up
  printf '\e[1;32m%s\e[m\n' GOOD
  ((lw = up))
  ((up *= 2))
done

while :
do
  ((k = (lw + up) / 2))
  ((k == lw)) && break
  printf '%d\t' $k
  if wget -q --spider $url$k
  then
    printf '\e[1;32m%s\e[m\n' GOOD
    ((lw = k))
  else
    printf '\e[1;31m%s\e[m\n' BAD
    ((up = k))
  fi
done
