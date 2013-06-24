# FIXME weighted categories

querystring ()
{
  sed 'y/ /&/' <<< ${qs[*]}
}

try ()
{
  dur=$1
  qs[2]=trackid=$2
  json=$3
  if ! [ -a $json ]
  then
    curl -s api.acoustid.org/v2/lookup?`querystring` | jq .results[0] > $json
  fi
  set .sources "($dur - (.duration // 0) | . * .)"
  jq ".recordings | max_by(.2 * $1 - .8 * $2)" $json
}

qs[0]=client=8XaBELgH
qs[1]=meta=recordings+sources

# acoustid.org/track/b5dcad58-6e4e-453e-828e-c789e6a515fd
try 308 b5dcad58-6e4e-453e-828e-c789e6a515fd unfinished-sympathy.json

# acoustid.org/track/b2e48096-2183-4482-8492-b33b09760f4c
try 471 b2e48096-2183-4482-8492-b33b09760f4c protection.json
