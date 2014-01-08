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
  qq=$(( set -x
         : "$@" )2>&1)
  warn "${qq:2}"
  eval "${qq:2}"
}

(( $# )) || usage
arg_rpo=$1
git ls-remote git://github.com/$arg_rpo.git > y

# Get last tag
tag=$(awk -F[/^] 'END{print $3}' y)

# Get HEAD SHA
sha=$(awk NR==1,NF=1 FPAT=.{7} y)

# Get commits to HEAD
log curl -ksoy https://api.github.com/repos/$arg_rpo/compare/$tag...HEAD
commits=$(awk '/total_commits/{print $2}' FPAT='[^ ,]+' y)
echo "$tag-$commits-g$sha"
rm y
