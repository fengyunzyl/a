# http://superuser.com/q/611538

x=$(date +%s.%N)
while y=$(date +%s.%N)
do
  printf '%.11s\r' $(date +%T.%N -ud@$(awk "BEGIN{print($y-$x)}"))
done
