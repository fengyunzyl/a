
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
  printf '\e[36m%s\e[m\n' "$*" >&2
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

. <(fpcalc "$1" | sed 1d)

qs=(
  client=8XaBELgH
  duration=$DURATION
  fingerprint=$FINGERPRINT
)

for meta in "${metas[@]}"
do
  warn $meta
  qs[3]=$meta
  curl -s api.acoustid.org/v2/lookup?`querystring` | jq .
done
