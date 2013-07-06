# git add .      modified and new files
# git add -u     modified and deleted files
# git add -A     modified, new and deleted files
# git commit -a  modified and deleted files

set "$(git status -s)"
git add -A
git commit -m "$1"
