function hr {
  sed '
  1d
  $d
  s/  //
  ' <<< "$1"
}

if (( $# != 2 ))
then
  hr '
  printf.sh <E|S> INPUT
  E expression
  S string
  '
  exit
fi

ag=$2
if [[ $1 = S ]]
then
  printf -v ag '"%s"' "$2"
fi

bar=(
  %a %b %d %e %.0f %.7f
  %g %h %i %j %k %l %m %n %o %p %q %r %s %t %u %v %w %x %y %z
)

for foo in ${bar[*]}
do
  awk "BEGIN {printf \"%$foo\t$foo\n\", $ag}"
done
