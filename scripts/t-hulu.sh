# test for hulu.sh

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

log ()
{
  unset PS4
  qq=$((set -x; : "$@") 2>&1)
  warn "${qq:2}"
  eval "${qq:2}"
}

for aa in {1..10}
do
  printf '\ntry %s\n' $aa
  log sleep 70
  timeout 40 hulu.sh limelight 1000_h264 hulu.com/watch/477963
done
