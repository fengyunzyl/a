#!/bin/sh
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
for var_leng in {1..8}
do
  # starting letter
  for sta_lett in {1..26}
  do
    awk '
    NR >= a && NR < a+b {
      print substr($0, 1, c)
    }
    ' a=$sta_lett b=$num_vars c=$var_leng /tmp/nfa_file >/tmp/pat_file
    if [ `wc -l </tmp/pat_file` -lt $num_vars ]
    then
      continue
    fi
    awk '{printf $0 FS}' /tmp/pat_file
    if grep --quiet --file /tmp/pat_file "$inp_file"
    then
      echo BAD
    else
      echo GOOD
      exit
    fi
  done
done
