git reset -q
git add -A "$@"

# print first added line if found, else print first removed line
mg=$(git diff --cached --color | perl -F -ane '
/^\033\[3[12]m/ || next;
$F[3]==1 && $rd && next;
s.\033[^m]+m..g;
s.^[+-]\s*(#+ )*..;
$rd=$_;
$F[3]==2 && $rd && last;
END {
  print $rd
}
')

git commit -m "$mg"
