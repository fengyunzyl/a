set "$HOMEDRIVE\program files" "$HOMEDRIVE\program files (x86)"
echo these items can be removed

# clean up program files
for ac
do
  cd "$ac"
  for pg in *
  do
    if ! find "$pg" -iname '*.exe' | read
    then
      printf '\e[1;31m%s\e[m\n' "$ac\\$pg"
    fi
  done
done

# clean up local appdata
cd "$LOCALAPPDATA"
for pg in *
do
  [ -f "$pg" -o -h "$pg" ] && continue
  if ! find "$@" -maxdepth 1 -iname "$pg*" | read
  then
    printf '\e[1;31m%s\e[m\n' "$LOCALAPPDATA\\$pg"
  fi
done

# clean up appdata
cd "$APPDATA"
for pg in *
do
  [ -f "$pg" -o -h "$pg" ] && continue
  if ! find "$@" -maxdepth 1 -iname "$pg*" | read
  then
    if ! find "$pg" -iname '*.exe' | read
    then
      printf '\e[1;31m%s\e[m\n' "$APPDATA\\$pg"
    fi
  fi
done
