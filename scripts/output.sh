# print output of all commands
EDITOR=rm
lg=~+/output.log

# variables
set -o posix
set |
tee -a $lg

# builtins
help | awk '
NR > 8 {
  sub(" .+", "", $2)
  sub(" .+", "", $3)
  if ($2 ~ /\w+/) print $2
  if ($3 ~ /\w+/) print $3
}
' FIELDWIDTHS='1 40 37' |
sort |
while read bn
do
  op=$(</dev/null 2>/dev/null $bn)
  printf '%-11s%.68s\n' $bn "${op%%$'\n'*}" |
    tee -a $lg
done

# files
cd /tmp
for cm in /bin/*
do
  op=$(</dev/null 2>/dev/null timeout -s9 .1 $cm)
  printf '%-22s%.57s\n' $cm "${op%%$'\n'*}" |
    tee -a $lg
done
