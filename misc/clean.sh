pf=(
  "$HOMEDRIVE/program files"
  "$HOMEDRIVE/program files (x86)"
)

echo clean up program files
for ac in "${pf[@]}"
do
  cd "$ac"
  for pg in *
  do
    grep -iq 'windows defender' <<< "$pg" && continue
    find "$pg" -name '*.exe' -o -name '*.dll' | read && continue
    printf '\e[1;31m%s\e[m\n' "$PWD\\$pg"
  done
done

echo clean up local appdata
cd "$LOCALAPPDATA"
for pg in *
do
  [ -f "$pg" -o -h "$pg" ] && continue
  grep -iq temp <<< "$pg" && continue
  find "${pf[@]}" -maxdepth 1 -iname "$pg*" | read && continue
  printf '\e[1;31m%s\e[m\n' "$PWD\\$pg"
done

echo clean up appdata
cd "$APPDATA"
for parent in *
do
  find "$parent" -iname '*.exe' | read && continue

  # try parent
  find "${pf[@]}" -maxdepth 2 -iname "$parent*" | read && continue

  # try child
  cd "$parent"
  children=(*)
  cd ..
  for child in "${children[@]}"
  do
    find "${pf[@]}" -maxdepth 1 -iname "$child" | read && continue 2
  done

  printf '\e[1;31m%s\e[m\n' "$PWD\\$parent"
done
