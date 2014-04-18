# stackoverflow.com/q/9027584/how-to-change-the-file-mode-on-github

warn () {
  printf '\e[36m%s\e[m\n' "$*"
}

log () {
  unset PS4
  sx=$((set -x
    : "$@") 2>&1)
  warn "${sx:2}"
  "$@"
}

if (( $# != 1 ))
then
  echo ${0##*/} FILE
  exit
fi

# Change mode locally
log chmod 755 $1
log git update-index --skip-worktree --chmod=+x $1
log git update-index --no-skip-worktree $1
log git commit -m "change mode $1"
log git push
