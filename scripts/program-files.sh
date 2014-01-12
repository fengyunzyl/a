# clean up program files to recycle bin
ds=$PWD

for ac in 'program files' 'program files (x86)'
do
  cd "$HOMEDRIVE/$ac"
  mkdir -p "$ds/$ac"
  for pg in *
  do
    if ! find "$pg" -iname '*.exe' | read
    then
      mv "$pg" "$ds/$ac"
    fi
  done
done
