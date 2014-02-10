git reset -q
git add -A "$@"

# print first added line if found, else print first removed line
mg=$(git diff --cached --color | awk '
/^\033\[3[12]m/ {
  co=$4
  if (co==1 && rd) next
  gsub(/\033[^m]+m/, "")
  sub(/^[+-] *(#+ )*/, "")
  rd=$0
  if (co==2 && rd) exit
}
END {
  print rd
}
' FPAT=.)

git commit -m "$mg"
