# jq -r '.releases[].date' foo.json | xargs -l date +%s -d

querystring ()
{
  sed 'y/ /&/' <<< ${qs[*]}
}

try ()
{
  qs[2]=recording=$1
  json=$2
  if ! [ -a $json ]
  then
    curl -so $json musicbrainz.org/ws/2/release?`querystring`
  fi
  max_by=(
    .id
    .date
    '.packaging // "null"'
    '.["label-info"][0]["label"]["label-code"] // "null"'
    '(.media[0].discs | length)'
    '.["cover-art-archive"].count'
  )
  set "${max_by[@]}"
  jq -r ".releases[] | [$1, $2, $3, $4, $5, $6] | @csv" $json
  jq ".releases | max_by(.3 * $5 + .7 * $6).id" $json
  echo
}

qs[0]=fmt=json
qs[1]=inc=discids+labels

try '823de184-19a6-4420-80b4-265afa81999c' blue-lines.json
try '9e599661-19a1-4941-958b-5d66e0da5c79' protection.json
try '8e74dd9d-e5a3-4acd-918a-c36a0f8cda84' mezzanine.json
try 'cfb5a0cf-29ff-4fb2-bdad-24cbb70cdd03' future-proof.json
