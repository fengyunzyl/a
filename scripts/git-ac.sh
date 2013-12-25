git add -A "$1"

# print first added line if found, else print first removed line
y=$(git diff --cached --color | awk '
/^\033\[3[12]m/ {
  c=$4
  if (c==1 && m) next
  gsub(/\033[^m]+m/, "")
  sub(/^[+-] *(#+ )*/, "")
  m=$0
  if (c==2 && m) exit
}
END {
  print m
}
' FPAT=.)

git commit -m "$y"
