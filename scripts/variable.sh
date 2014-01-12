# find unused variable names

usage () {
  echo usage: ${0##*/} WORD FILE
  exit
}

(( $# < 2 )) && usage
read -d '' arg_file < "$2"
b=$(awk NF=NF OFS=, FPAT=[^aeilou] <<< ${1:1})
eval set ${1::1}{$b}
declare -A cans

for foo
do
  [[ $arg_file =~ $foo  ]] && continue
  [[ $foo      =~ ar|at ]] && continue
  cans[$foo]=
done

for can in "${!cans[@]}"
do
  echo $can
done
