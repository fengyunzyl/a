
warn ()
{
  printf '\e[1;35m%s\e[m\n' "$*"
}

for k in /opt/*/
do
  printf '\ec'
  cd $k
  git status
  warn $k
  read
done
