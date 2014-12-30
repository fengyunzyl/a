# A mosaic in digital imaging is a plurality of non-overlapping images, arranged
# in some tessellation.
mapfile usage <<+
mosaic.sh [options] [files]

-d             dry run, create pieces only

-s shave       how much to shave
               example  6x6

-c crop        comma separated list of crops
               example  -300,0,+300,0

-g gravity     comma separated list of gravities
               example  north,south,east,southeast

-r resize      comma separated list of resize markers
               example  y,y,y,n

-m dimensions  comma separated list of dimensions
               example  1920x1080,1280x1080,960x1080,640x1080
+
readonly usage

function mn {
  awk '{for (;NF-1;NF--) if ($1>$NF) $1=$NF} 1' RS=
}

function warn {
  printf '\e[36m%s\e[m\n' "$*"
}

function log {
  unset PS4
  sx=$((set -x
    : "$@") 2>&1)
  warn "${sx:2}"
  "$@"
}

type convert | grep -q bin || exit

if [ $# = 0 ]
then
  printf %s "${usage[@]}"
  exit
fi

while getopts ds:c:g:r:m: name
do
  case $name in
  d) dry=yes ;;
  s) sv=$OPTARG ;;
  c) IFS=, read -a eg <<< "$OPTARG" ;;
  g) IFS=, read -a gv <<< "$OPTARG" ;;
  r) IFS=, read -a rz <<< "$OPTARG" ;;
  m) IFS=, read -a dm <<< "$OPTARG" ;;
  esac
done
shift $((--OPTIND))

sc=("$@")

if [ ${#rz[*]} = 0 ]
then
  rz=("$@")
else
  rz=("${rz[@]/n}")
fi

ao=$(identify -format '%[fx:w/h>1]' "$@")
if [ ${#dm} = 0 ]
then
  case $ao in
    11) dm=({1920,1920}x1080) ;;
    001) dm=({960,960,1920}x1080) ;;
    0101) dm=({640,1280,640,1280}x1080) ;;
    0110) dm=({640,1280,1280,640}x1080) ;;
    1001) dm=({1280,640,640,1280}x1080) ;;
    1010) dm=({1280,640,1280,640}x1080) ;;
    1111) dm=({960,960,960,960}x1080) ;;
    0111) dm=({640,1280,960,960}x1080) ;;
    1011) dm=({1280,640,960,960}x1080) ;;
    1101) dm=({960,960,640,1280}x1080) ;;
    1110) dm=({960,960,1280,640}x1080) ;;
    00001) dm=({640,640,640,640,1280}x1080) ;;
    00010) dm=({640,640,640,1280,640}x1080) ;;
    01000) dm=({640,1280,640,640,640}x1080) ;;
    10000) dm=({1280,640,640,640,640}x1080) ;;
    00011) dm=({640,640,640,960,960}x1080) ;;
    11000) dm=({960,960,640,640,640}x1080) ;;
    000000) dm=({640,640,640,640,640,640}x1080) ;;
    110110) dm=(960x{540,540,1080,540,540,1080}) ;;
    0000110) dm=(640x{1080,1080,1080,1080,540,540,1080}) ;;
  esac
fi

# crop images
for ((o=0; o<$#; o++))
do
  log convert -quality 100 \
  ${sv+-shave $sv} \
  ${eg[o]:+-crop ${eg[o]}} \
  ${gv[o]:+-gravity ${gv[o]}} \
  ${rz[o]:+-resize ${dm[o]}^} \
  -extent ${dm[o]} \
  {,=}"${sc[o]}"
done

# combine
${dry+exit}

ht=$(identify -format '%h\n' "$@" | mn)
set =*
case $ao in
110110) log convert -quality 100 +append \
  '(' -append "$1" "$2" ')' \
  "$3" \
  '(' -append "$4" "$5" ')' \
  "$6" \
  out-$ht.jpg ;;
0000110) log convert -quality 100 +append \
  "$1" "$2" "$3" "$4" \
  '(' "$5" "$6" -append ')' \
  "$7" \
  out-$ht.jpg ;;
*) log convert -quality 100 +append "$@" out-$ht.jpg ;;
esac
rm "$@"
