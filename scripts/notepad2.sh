mapfile u </etc/mtab
for (( v=${#u[*]}-1; v>=0; v-- ))
do
  set "$1" ${u[v]}
  set "${1/#$3/$2/}"
done
"$ProgramW6432/notepad2/notepad2" "$1"
