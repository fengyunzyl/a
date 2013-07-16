# Git, find out which files have had the most commits

git rev-list --objects --all |
awk '"" != $2'               |
sort -k2                     |
uniq -cf1                    |
sort -rn                     |
while read frequency sample path
do 
  [[ -a $path ]] && [ $(git cat-file -t $sample) = blob ] &&
    printf '%s\t%s\n' "$frequency" "$path"
done
