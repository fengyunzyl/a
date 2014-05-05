# find unused variable names
if (( $# != 3 ))
then
  echo ${0##*/} WORD LENGTH FILE
  exit
fi

arg_wd=$1
arg_ln=$2
read -d '' arg_fe < "$3"
sc=$(awk NF=NF OFS=, FPAT=[^aeilou] <<< "${arg_wd:1}")

if (( arg_ln == 2 ))
then
  eval set "${arg_wd::1}"{$sc}
else
  eval set "${arg_wd::1}"{$sc}{$sc}
fi

declare -A cans

for pm
do
  [[ $pm     =~ ar|at|pr ]] && continue
  [[ $arg_fe =~ $pm      ]] && continue
  cans[$pm]=
done

for can in "${!cans[@]}"
do
  echo $can
done
