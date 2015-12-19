#!/bin/dash
if [ $# != 2 ]
then
  echo 'nato.sh [# of variables] [file]'
  exit
fi
num_vars=$1
inp_file=$2
cat >/tmp/nfa_file <<+
alpha
bravo
charlie
delta
echo
foxtrot
golf
hotel
india
juliet
kilo
lima
mike
november
oscar
papa
quebec
romeo
sierra
tango
uniform
victor
whiskey
xray
yankee
zulu
+
# length of variable name - november is longest
# FIXME variable names need to be same length
var_leng=
while [ $((var_leng+=1)) -le 8 ]
do
  # starting letter
  sta_lett=
  while [ $((sta_lett+=1)) -le 26 ]
  do
    awk '
    NR >= x && NR < x+y {
      print substr($0, 1, z)
    }
    ' x=$sta_lett y=$num_vars z=$var_leng /tmp/nfa_file >/tmp/pat_file
    if [ $((26-sta_lett+1)) -lt $num_vars ]
    then
      continue
    fi
    awk '{printf $0 FS}' /tmp/pat_file
    if grep --quiet --ignore-case --file /tmp/pat_file "$inp_file"
    then
      echo BAD
    else
      echo GOOD
      exit
    fi
  done
done
