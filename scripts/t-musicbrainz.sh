# jq -r '.releases[].date' foo.json | xargs -l date +%s -d

querystring ()
{
  sed 'y/ /&/' <<< ${qs[*]}
}

try ()
{
  qs[2]=recording=$2
  curl -so $1 musicbrainz.org/ws/2/release?`querystring`
  pp=.id
  qq=.date
  rr='.packaging // "null"'
  ss='.["label-info"][0]["label"]["label-code"] // "null"'
  tt='(.media[0].discs | length)'
  uu='.["cover-art-archive"].count'
  jq -r ".releases[] | [$pp, $qq, $rr, $ss, $tt, $uu] | @csv" $1
  jq ".releases | max_by(.3 * $tt + .7 * $uu).id" $1
  echo
}

qs[0]=fmt=json
qs[1]=inc=discids+labels

try blue-lines.json '823de184-19a6-4420-80b4-265afa81999c'
try protection.json '9e599661-19a1-4941-958b-5d66e0da5c79'
try mezzanine.json '8e74dd9d-e5a3-4acd-918a-c36a0f8cda84'
