# Git remove sensitive data
# help.github.com/articles/remove-sensitive-data

usage () {
  echo "Usage:  $0 FILE"
  exit
}

(( $# )) || usage

git filter-branch \
  --index-filter "git rm --cached --ignore-unmatch '$1'" \
  --prune-empty --tag-name-filter cat -- --all || exit

# Cleanup and reclaming space
rm -r .git/refs/original
git reflog expire --expire=now --all
git gc --prune=now
git gc --aggressive --prune=now
