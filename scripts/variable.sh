# find unused variable names

usage()
{
  echo usage: $0 NUMBER [FILE]
  exit
}

[ $1 ] || usage
arg_num=$1

if [ $2 ]
then
  read -d '' arg_file < "$2"
else
  read -d '' arg_file
fi

# one character
bad=( i j l )
bbb=()
for aaa in {a..z}
do
  if [[ $arg_file =~ $aaa ]]
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
  if [[ $arg_file =~ $aaa$aaa ]]
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
