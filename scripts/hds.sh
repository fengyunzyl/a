# seek with Adobe HTTP Dynamic Streaming

usage ()
{
  echo usage: $0 COMMAND
  exit
}

warn ()
{
  printf '\e[36m%s\e[m\n' "$*" >&2
}

(( $# )) || usage
shift 2

while :
do
  warn '[#,q]?'
  read line
  if [[ $line =~ ^[0-9]+$ ]]
  then
    php /opt/scripts/adobehds.php --play --start $line $* |
      ffplay -v warning - &
    sleep 6
    [ $OLD ] && kill -13 $OLD
    OLD=$!
  elif [[ $line = q ]]
  then
    exit
  else
    warn '# - start fragment'
    warn 'q - quit'
  fi
done
