# http://superuser.com/q/611538

x=$(date +%s.%N)
while :
do
  y=$(date +%s.%N)
  printf '%.11s\r' $(date +%T.%N -ud@$(awk "BEGIN{print($y-$x)}"))
done
