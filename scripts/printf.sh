if (( $# != 2 ))
then
  echo "${0##*/} <E|S> INPUT"
  echo "E expression"
  echo "S string"
  exit
fi

ag=$2
[ $1 = S ] && ag=\"$2\"

bar=(
  %a %b %d %e %.7f %g %h %i %j %k %l %m %n %o %p %q %r %s %t %u %v %w %x %y %z
)

for foo in ${bar[*]}
do
  awk "BEGIN {printf \"%$foo\t$foo\n\", $ag}"
done
