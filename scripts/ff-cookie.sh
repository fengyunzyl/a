# FFplay with cookies

usage ()
{
  echo "usage: $0 COOKIE URL"
  echo
  echo "example cookie:  sbsession=sbg&sbuser=lorem"
  exit
}

[ $2 ] || usage
printf -v q 'Cookie: %s\r\n' "$1"
ffplay -headers "$q" "$2"
