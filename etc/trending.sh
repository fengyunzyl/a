#!/bin/dash
if [ $# != 3 ]
then
  echo 'trending.sh [page] [language] [maxsize]'
  exit
fi
if [ "$3" -ge 10000000000 ]
then
  echo 'maxsize too high'
  exit
fi

cd /tmp
# For unauthenticated requests, the rate limit allows you to make up to 5
# requests per minute.
curl --get --remote-name \
--data-urlencode page="$1" --data-urlencode q="size:<=$3 language:$2" \
https://api.github.com/search/repositories

printf '\33[1;32m%s\33[m\n' "star count and size of $2 repos under $3 kB"

jq -r '
.items[] |
"\(.stargazers_count)\t\(.size)\t\(.language)\t\(.html_url)\t\(.description)"
' repositories |
awk '
BEGIN {
  FS = "\t"
}
{
  v = sprintf("%s %s %s \33[1;31m%s\33[m %s", $1, $2, $3, substr($4, 20), $5)
  print substr(v, 0, 79 + 10)
}
' |
sort -nr
