# find unused variable names

usage ()
{
  echo usage: $0 NUMBER [FILE]
  exit
}

build ()
{
  printf -v ccc "%$1s"
  bbb=()
  for aaa in {a..z}
  do
    ccc=${ccc//?/$aaa}
    if [[ $arg_file =~ $ccc ]]
    then
      bbb=()
    elif [[ ${bad[*]} =~ $ccc ]]
    then
      bbb=()
    else
      bbb+=($ccc)
    fi
    if [ ${#bbb[*]} = $arg_num ]
    then
      echo ${bbb[*]}
      exit
    fi
  done
}

[ $1 ] || usage
arg_num=$1

if [ $2 ]
then
  read -d '' arg_file < "$2"
else
  read -d '' arg_file
fi

arg_file=${arg_file,,}

# one character
bad=( i j l )
build 1

# two characters
bad=( cc dd ii jj ll )
build 2

# three characters
bad=( iii jjj lll )
build 3
