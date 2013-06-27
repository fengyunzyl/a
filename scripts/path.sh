
echo FOLDER "'$1'"
echo $(find $1 -maxdepth 1 -executable -type f | wc -l) files
