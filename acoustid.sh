
usage ()
{
  echo usage: $0 FILE
  exit
}

warn ()
{
  printf '\e[36m%s\e[m\n' "$*" >&2
}

json ()
{
  read $1 < <(jq -r .$2 jq.json)
}

log ()
{
  unset PS4
  coproc yy (set -x; : "$@") 2>&1
  read -r zz <&$yy
  warn ${zz:2}
  "$@"
}

[ $1 ] || usage

# get TITLE
log fpcalc "$1" > fp.sh
d2u -q fp.sh
. fp.sh
req="client=8XaBELgH&duration=${DURATION}&fingerprint=${FINGERPRINT}"
curl -s "api.acoustid.org/v2/lookup?${req}&meta=recordings+releaseids" |
  jq .results[0].recordings[0] > jq.json
json TITLE title
json ID releases[0].id

# get ALBUM ARTIST LABEL DATE
set 'fmt=json&inc=artist-credits+labels'
log curl -s "musicbrainz.org/ws/2/release/${ID}?${1}" > jq.json
json ALBUM title
json ARTIST '["artist-credit"][0].name'
json LABEL '["label-info"][0].label.name'
json DATE date
echo $TITLE
echo $ALBUM
echo $ARTIST
echo $LABEL
echo $DATE
rm fp.sh jq.json
