# find current files with most commits, including renames

git ls-files |
while read aa
do
  printf . >&2
  set $(git log --follow --oneline "$aa" | wc)
  printf '%s\t%s\n' $1 "$aa"
done > bb

echo
sort -nr bb
rm bb
