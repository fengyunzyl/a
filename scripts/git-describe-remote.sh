# Should be v1.8.0.1-343-gf94c325

usage ()
{
  echo usage: $0 torvalds/linux
  exit
}

warn ()
{
  printf '\e[36m%s\e[m\n' "$*" >&2
}

log ()
{
  unset PS4
  set $((set -x; : "$@") 2>&1)
  shift
  warn $*
  eval $*
}

[ $1 ] || usage
arg_rpo=$1
git ls-remote git://github.com/$arg_rpo.git > k

# Get last tag
set $(sed '$!d; y./^.  .' k)
tag=$4

# Get HEAD SHA
sha=$(sed '1!d; s/.//8g' k)

# Get commits to HEAD
log wget -qOk https://api.github.com/repos/$arg_rpo/compare/$tag...HEAD
commits=$(sed '/total_commits/!d; s/[^0-9]//g' k)
echo "$tag-$commits-g$sha"
rm k
