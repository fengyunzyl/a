# test for hulu.sh

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

log ()
{
  unset PS4
  set $((set -x; : "$@") 2>&1)
  shift
  warn $*
  eval $*
}

for aa in {1..10}
do
  printf '\ntry %s\n' $aa
  log sleep 60
  timeout 20 hulu.sh limelight 1000_h264 hulu.com/watch/441271
done
