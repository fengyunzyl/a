# coredump with 3 sample points
coredump ()
{
  PID=$!
  echo waiting for $1 to load...
  uu=0
  vv=0
  while sleep 1
  do
    mapfile ww </proc/$PID/maps
    (( xx = vv - uu ))
    (( yy = ${#ww[*]} - vv ))
    if (( ${xx/-} + ${yy/-} < 10 ))
    then
      break
    fi
    uu=$vv
    vv=${#ww[*]}
  done
  echo dumping $1...
  read WINPID </proc/$PID/winpid
  dumper ff $WINPID 2>&- &
  until [ -s ff.core ]
  do
    sleep 1
  done
  kill -13 $PID
}
