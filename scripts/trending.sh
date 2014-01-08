
usage () {
  echo usage: $0 PAGE LANGUAGE SIZE
  exit
}

(( $# < 3 )) && usage

# For unauthenticated requests, the rate limit allows you to make up to 5
# requests per minute.
curl https://api.github.com/search/repositories?page=$1 -Gso repos.json \
  --data-urlencode "q=size:<$3 language:$2" \
  --data-urlencode sort=stars \
  --data-urlencode order=desc

printf '\e[1;32m%s\e[m\n' "size and star counts of $2 repos under $3 kB"

jq -r '.items[] |
  "\(.size)\t\(.stargazers_count)\t\(.language)\t\(.html_url)\t\(.description)"' repos.json |
  awk '{
  v = sprintf("%s %s %s \033[1;31m%s\033[m %s",
    $1,
    $2,
    $3,
    substr($4, 20),
    $5)
  print substr(v, 0, 79 + 10)
  }' FS='\t' |
  sort -nr

rm repos.json
