# Should be v1.8.0.1-343-gf94c325

usage () {
  echo usage: $0 torvalds/linux
  exit
}

warn () {
  printf '\e[36m%s\e[m\n' "$*" >&2
}

log () {
  unset PS4
  sx=$(( set -x
         : "$@" )2>&1)
  warn "${sx:2}"
  eval "${sx:2}"
}

(( $# )) || usage
arg_rpo=$1
git ls-remote git://github.com/$arg_rpo.git > ,

# Get last tag
tag=$(awk 'END{print$3}' FS=[/^] ,)

# Get HEAD SHA
sha=$(awk NR==1,NF=1 FPAT=.{7} ,)

# Get commits to HEAD
log curl -kso, https://api.github.com/repos/$arg_rpo/compare/$tag...HEAD
commits=$(awk '/total_commits/{print $2}' FPAT='[^ ,]+' ,)
echo "$tag-$commits-g$sha"
rm ,
