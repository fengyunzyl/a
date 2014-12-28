# find unused variable names
get_withdraws_without_replacement () {
  local n=$1 h r=()
  shift
  (( n > 0 )) || return
  if (( n == 1 ))
  then
    gwwr_ret=("$@")
    return
  fi
  while (( $# >= n ))
  do
    h=$1
    shift
    get_withdraws_without_replacement $((n-1)) "$@"
    r+=("${gwwr_ret[@]/#/$h}")
  done
  gwwr_ret=("${r[@]}")
}

mapfile usage <<+
variable.sh WORD LENGTH [ALL] FILE

if you use "ALL", "aeilou" will be included
+
if [ $# -lt 3 ]
then
  printf %s "${usage[@]}"
  exit
fi

awd=$1
ale=$2
if [[ $4 ]]
then
  gd=.
else
  gd=[^aeilou]
fi
read -d '' afi < "${!#}"
c1=${awd::1}
set -- $(awk '!s[RT]++ && RT~gd && $0=RT' gd=$gd RS=[[:alnum:]] <<< ${awd:1})
get_withdraws_without_replacement $((ale-1)) $*
shopt -s nocasematch

for each in ${gwwr_ret[*]}
do
  case $c1$each in
    ar|cc|cp|dc|pg|pr|ps)
      echo $c1$each is a command
      continue
    ;;
  esac
  if [[ $afi =~ $c1$each ]]
  then
    continue
  fi
  echo $c1$each
done
