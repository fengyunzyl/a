# find duplicates on the path

for dr in ${PATH//:/ }
do
  if [ -a "$dr" ]
  then
    cd "$dr"
  fi
  for fe in *
  do
    printf . >&2
    if (( $(type -a "$fe" 2>/dev/null | wc -l) > 1 ))
    then
      printf '\n%s\n' "$fe"
    fi
  done
done
