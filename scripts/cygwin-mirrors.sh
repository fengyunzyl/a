# Print Cygwin mirrors

curl -s sourceware.org/cygwin/mirrors.lst |
  awk '/http/ && /United States/ {print length($1), $1}' FS=';' |
  sort
