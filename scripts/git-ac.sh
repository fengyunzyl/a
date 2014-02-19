git reset -q
git add -A "$@"

# print first added line if found, else print first removed line
mg=$(git diff --cached --color | awk '
/^\033\[3[12]m/ {
  if ($4==1 && rd) next
  gsub(/\033[^m]+m/, "")
  sub(/^[+-] *(#+ )*/, "")
  rd=$0
  if ($4==2 && rd) exit
}
END {
  print rd
}
' FPAT=.)

git commit -m "$mg"
