
usage ()
{
  echo usage: $0 FILE
  exit
}

querystring ()
{
  sed 's/ /\&/g' <<< ${qs[*]}
}

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

[[ $1 ]] || usage

metas=(
  meta=
  meta=recordings
  meta=recordingids
  meta=releases
  meta=releaseids
  meta=releasegroups
  meta=releasegroupids
  meta=tracks
  meta=puids
  meta=compress
  meta=usermeta
  meta=sources
)

eval $(fpcalc "$1" | sed 1d)

for meta in "${metas[@]}"
do
  warn $meta
  qs=(
    client=8XaBELgH
    duration=$DURATION
    fingerprint=$FINGERPRINT
    $meta
  )
  curl -s api.acoustid.org/v2/lookup?`querystring` | jq .
done
