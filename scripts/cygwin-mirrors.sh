# Print Cygwin mirrors

IFS=/ read ee ff <<< sourceware.org/cygwin/mirrors.lst
exec 3< /dev/tcp/$ee/80
{
  echo GET /$ff
  echo connection: close
  echo host: $ee
} >&3

grep 'United States' <&3 |
  grep http |
  cut -d';' -f1 |
  while read gg
  do
    echo "${#gg} $gg"
  done |
  sort
