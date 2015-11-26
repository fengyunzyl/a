#!/bin/sh
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
  sx=$(sh -xc ': "$@"' . "$@" 2>&1)
  warn "${sx:4}"
  "$@"
}

if ! convert -version &>/dev/null
then
  echo convert not found
  exit
fi

if ! identify -version &>/dev/null
then
  echo identify not found
  exit
fi

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

if [ ${#dm} = 0 ]
then
  ao=$(identify -format '%[fx:w/h>1]' "$@")
  case $ao in
    11) dm=({1920,1920}x1080) ;;
    001) dm=({960,960,1920}x1080) ;;
    110) dm=({1920,1280,640}x1080) ;;
    0001) dm=(640x1080{,,} 1920x1080) ;;
    0101) dm=({640,1280,640,1280}x1080) ;;
    0110) dm=({640,1280,1280,640}x1080) ;;
    1000) dm=({1920,640,640,640}x1080) ;;
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
    000011) dm=(640x1080 640x1080 640x1080 960x1080 960x540 960x540) ;;
    000110) dm=(640x1080 640x1080 640x1080 960x540 960x540 960x1080) ;;
    011011) dm=(960x{1080,540,540,1080,540,540}) ;;
    110000) dm=(960x540 960x540 960x1080 640x1080 640x1080 640x1080) ;;
    110011) dm=(960x540 960x540 960x1080 960x1080 960x540 960x540) ;;
    110110) dm=(960x{540,540,1080,540,540,1080}) ;;
    0000110) dm=(640x{1080,1080,1080,1080,540,540,1080}) ;;
    *)
      echo cannot automatically set dimensions
      exit
    ;;
  esac
fi

# extent must come after resize
for ((o=0; o<$#; o++))
do
  log convert -quality 100 \
  ${sv+-shave $sv} \
  ${eg[o]:+-crop ${eg[o]}} \
  ${rz[o]:+-resize ${dm[o]}^} \
  -extent ${dm[o]} \
  -gravity ${gv[o]:-center} \
  {,=}"${sc[o]}"
done

# combine
${dry+exit}

set =*
case $ao in
000011) log convert \
  "$1" "$2" "$3" "$4" '(' "$5" "$6" -append ')' +append \
  -quality 100 out ;;
000110) log convert \
  "$1" "$2" "$3" '(' "$4" "$5" -append ')' "$6" +append \
  -quality 100 out ;;
011011) log convert \
  "$1" '(' "$2" "$3" -append ')' "$4" '(' "$5" "$6" -append ')' +append \
  -quality 100 out ;;
110000) log convert \
  '(' "$1" "$2" -append ')' "$3" "$4" "$5" "$6" +append \
  -quality 100 out ;;
110011) log convert \
  '(' "$1" "$2" -append ')' "$3" "$4" '(' "$5" "$6" -append ')' +append \
  -quality 100 out ;;
110110) log convert \
  '(' "$1" "$2" -append ')' "$3" '(' "$4" "$5" -append ')' "$6" +append \
  -quality 100 out ;;
0000110) log convert \
  "$1" "$2" "$3" "$4" '(' "$5" "$6" -append ')' "$7" +append \
  -quality 100 out ;;
*) log convert "$@" +append -quality 100 out ;;
esac

sn=$(basename ~+)
ht=$(identify -format '%h\n' "$@" | mn)
log mv out "s $sn h $ht".jpg
log rm "$@"
