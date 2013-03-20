
usage ()
{
  echo usage: $0 FILE
  exit
}

warn ()
{
  printf '\e[36m%s\e[m\n' "$*" >&2
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
log fpcalc "$1" > fpcalc.sh
d2u -q fpcalc.sh
log . fpcalc.sh
rm fpcalc.sh
required="client=8XaBELgH&duration=$DURATION&fingerprint=$FINGERPRINT"
# recordings holds TITLE and ARTIST
# releases holds ALBUM and DATE
optional='meta=recordings+releases'

curl -s "api.acoustid.org/v2/lookup?${required}&${optional}" |
  jq .results[0].recordings[0] > meta.json

read TITLE < <(jq -r .title meta.json)
read ALBUM < <(jq -r .releases[0].title meta.json)
read ARTIST < <(jq -r .artists[0].name meta.json)
read DATE < <(jq .releases[0].date.year meta.json)

echo $TITLE
echo $ALBUM
echo $ARTIST
echo $DATE

rm meta.json
