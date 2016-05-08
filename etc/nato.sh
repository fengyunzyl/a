#!/bin/dash
if [ "$#" != 2 ]
then
  echo 'nato.sh [# of variables] [file]'
  exit
fi
num_vars=$1
inp_file=$2
cat >/tmp/nfa_file <<+
alfa
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
var_leng=
while [ $((var_leng+=1)) -le 8 ]
do
  # starting letter
  sta_lett=
  while [ $((sta_lett+=1)) -le 26 ]
  do
    end_lett=$((sta_lett+num_vars-1))
    if [ $end_lett -gt 26 ]
    then
      continue
    fi
    awk '
    NR == x, NR == y {
      if (length < z) exit 1
      print substr($0, 1, z)
    }
    ' x=$sta_lett y=$end_lett z=$var_leng /tmp/nfa_file >/tmp/pat_file
    if [ "$?" = 1 ]
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
