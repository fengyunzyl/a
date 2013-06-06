# FIXME weighted categories

querystring ()
{
  sed 'y/ /&/' <<< ${qs[*]}
}

JQ ()
{
  jq -r "$@" .json | tr -d '\r'
}

try ()
{
  qs[2]=trackid=$2
  curl -s api.acoustid.org/v2/lookup?`querystring` | jq .results[0] > .json
  JQ ".recordings | max_by(.sources - 3 * ($1 - (.duration // 0) | . * .))"
}

qs[0]=client=8XaBELgH
qs[1]=meta=recordings+sources

# unfinished sympathy
# acoustid.org/track/b5dcad58-6e4e-453e-828e-c789e6a515fd
try 308 b5dcad58-6e4e-453e-828e-c789e6a515fd

# protection
# acoustid.org/track/b2e48096-2183-4482-8492-b33b09760f4c
try 471 b2e48096-2183-4482-8492-b33b09760f4c
