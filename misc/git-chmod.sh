# stackoverflow.com/q/9027584/how-to-change-the-file-mode-on-github

function warn {
  printf '\e[36m%s\e[m\n' "$*"
}

function log {
  sx=$(bash -xc ': "$@"' . "$@" 2>&1)
  warn "${sx:4}"
  "$@"
}

if [ $# != 1 ]
then
  echo git chmod.sh FILE
  exit
fi

# Change mode locally
log chmod 755 $1
log git update-index --skip-worktree --chmod=+x $1
log git update-index --no-skip-worktree $1
log git commit -m "change mode $1"
log git push
