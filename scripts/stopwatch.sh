# http://superuser.com/q/611538

x=$(date +%s)
while :
do
  y=$(date +%s)
  printf '%s\r' $(date +%T -ud@$((y-x)))
  sleep 1
done
