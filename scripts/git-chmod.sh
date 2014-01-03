# stackoverflow.com/q/9027584/how-to-change-the-file-mode-on-github

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

usage ()
{
  echo usage: $0 FILE
  exit
}

log ()
{
  unset PS4
  qq=$(( set -x
         : "$@") 2>&1)
  warn "${qq:2}"
  eval "${qq:2}"
}

(( $# )) || usage
# Change mode locally
log chmod 755 $1
log git update-index --skip-worktree --chmod=+x $1
log git update-index --no-skip-worktree $1
log git commit -m "change mode $1"
log git push
