# find unused variable names
if (( $# < 3 ))
then
  echo ${0##*/} WORD LENGTH [ALL] FILE
  echo
  echo 'if you use "ALL", vowels will be included'
  exit
fi

arg_wd=$1
shift
arg_ln=$1
shift
if [[ $2 ]]
then
  fa='.'
  shift
else
  fa='[^aeilou]'
fi
read -d '' arg_fe < "$1"

sc=$(awk NF=NF OFS=, FPAT="$fa" <<< "${arg_wd:1}")

if (( arg_ln == 2 ))
then
  eval set "${arg_wd::1}"{$sc}
else
  eval set "${arg_wd::1}"{$sc}{$sc}
fi

declare -A cans

for pm
do
  [[ $pm     =~ ar|at|cp|dc|pr ]] && continue
  [[ $arg_fe =~ $pm            ]] && continue
  cans[$pm]=
done

for can in "${!cans[@]}"
do
  echo $can
done
