git reset -q
git add -A "$@"

# print first added line if found, else print first removed line
mg=$(git diff --cached --color | perl -F -ane '
/^\033\[3[12]m/ || next;
$co=$F[3];
$co==1 && $rd && next;
s.\033[^m]+m..g;
s.^[+-] *(#+ )*..;
$rd=$_;
$co==2 && $rd && last;
END {
  print $rd
}
')

git commit -m "$mg"
