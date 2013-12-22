# git add .      modified and new files
# git add -u     modified and deleted files
# git add -A     modified, new and deleted files
# git commit -a  modified and deleted files

set -- "$(git diff | awk '/^[+-][^+-]/ {print;exit}')"
git add -A
git commit -m "$1"
