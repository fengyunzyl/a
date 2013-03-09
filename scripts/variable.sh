# find unused variable names

usage()
{
  echo usage: $0 NUMBER FILE
  exit
}

[ $2 ] || usage
arg_num="$1"
arg_file="$2"

# one character
bad=( i j l )
bbb=()
for aaa in {a..z}
do
  if grep -q $aaa "$arg_file"
  then
    bbb=()
  elif [[ ${bad[*]} =~ $aaa ]]
  then
    bbb=()
  else
    bbb+=($aaa)
  fi
  if [ ${#bbb[*]} = $arg_num ]
  then
    break
  else
    false
  fi  
done

if [ $? = 0 ]
then
  echo ${bbb[*]}
  exit
fi

# two characters
bad=( cc dd ii jj ll )
bbb=()
for aaa in {a..z}
do
  if grep -q $aaa$aaa "${arg_file}"
  then
    bbb=()
  elif [[ ${bad[*]} =~ $aaa$aaa ]]
  then
    bbb=()
  else
    bbb+=($aaa$aaa)
  fi
  if [ ${#bbb[*]} = $arg_num ]
  then
    break
  fi
done

echo ${bbb[*]}
