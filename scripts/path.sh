# the script will count number of files with good extensions.
# the script will also list the "bad" extensions found.
# this way i can add to the list if necessary.
# we are not going to count scripts with no extension. those should be
# symbolic links. Good thing about extension is we dont have to worry if the
# file is executable.

usage ()
{
  echo "usage: ${0##*/} FOLDER"
  exit
}

(( $# )) || usage
good='\.(exe|sh)$'
declare -A bad
ct=0

for item in "$1"/*
do
  # need to filter out directories
  [ -d "$item" ] && continue
  if [[ $item =~ $good ]]
  then
    (( ct++ ))
  else
    # make note of the extension
    exn=$(awk '$NF ~ /\./ {sub(/.*\./,"",$NF); print $NF}' FS=/ <<< $item)
    [ $exn ] && bad[$exn]=
  fi
done

printf '%s\n  %s\n\n' 'good extensions'      "$ct"
printf '%s\n'         'discarded extensions'

for item in "${!bad[@]}"
do
  printf '  %s\n' $item
done
