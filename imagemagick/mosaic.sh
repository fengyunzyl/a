#!/bin/sh
# A mosaic in digital imaging is a plurality of non-overlapping images, arranged
# in some tessellation.
usage="\
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
"

mn() {
  awk '{for (;NF-1;NF--) if ($1>$NF) $1=$NF} 1' RS=
}

warn() {
  printf '\e[36m%s\e[m\n' "$*"
}

xc() {
  awk '
  BEGIN {
    x = "\47"
    printf "\33[36m"
    while (++i < ARGC) {
      y = split(ARGV[i], z, x)
      for (j in z) {
        printf z[j] ~ /[^[:alnum:]%+,./:=@_-]/ ? x z[j] x : z[j]
        if (j < y) printf "\\" x
      }
      printf i == ARGC - 1 ? "\33[m\n" : FS
    }
  }
  ' "$@" | fmt -80
  "$@"
}

if ! convert -version 2>&1 >/dev/null
then
  echo convert not found
  exit
fi

if ! identify -version 2>&1 >/dev/null
then
  echo identify not found
  exit
fi

if [ "$#" = 0 ]
then
  printf "$usage"
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
shift $((OPTIND-1))

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
    11) dm=(1920x1080 1920x1080) ;;
    001) dm=(960x1080 960x1080 1920x1080) ;;
    110) dm=(1920x1080 1280x1080 640x1080) ;;
    0001) dm=(640x1080 640x1080 640x1080 1920x1080) ;;
    0101) dm=(640x1080 1280x1080 640x1080 1280x1080) ;;
    0110) dm=(640x1080 1280x1080 1280x1080 640x1080) ;;
    1000) dm=(1920x1080 640x1080 640x1080 640x1080) ;;
    1001) dm=(1280x1080 640x1080 640x1080 1280x1080) ;;
    1010) dm=(1280x1080 640x1080 1280x1080 640x1080) ;;
    1111) dm=(960x1080 960x1080 960x1080 960x1080) ;;
    0111) dm=(640x1080 1280x1080 960x1080 960x1080) ;;
    1011) dm=(1280x1080 640x1080 960x1080 960x1080) ;;
    1101) dm=(960x1080 960x1080 640x1080 1280x1080) ;;
    1110) dm=(960x1080 960x1080 1280x1080 640x1080) ;;
    00001) dm=(640x1080 640x1080 640x1080 640x1080 1280x1080) ;;
    00010) dm=(640x1080 640x1080 640x1080 1280x1080 640x1080) ;;
    01000) dm=(640x1080 1280x1080 640x1080 640x1080 640x1080) ;;
    10000) dm=(1280x1080 640x1080 640x1080 640x1080 640x1080) ;;
    00011) dm=(640x1080 640x1080 640x1080 960x1080 960x1080) ;;
    11000) dm=(960x1080 960x1080 640x1080 640x1080 640x1080) ;;
    000000) dm=(640x1080 640x1080 640x1080 640x1080 640x1080 640x1080) ;;
    000011) dm=(640x1080 640x1080 640x1080 960x1080 960x540 960x540) ;;
    000110) dm=(640x1080 640x1080 640x1080 960x540 960x540 960x1080) ;;
    011011) dm=(960x1080 960x540 960x540 960x1080 960x540 960x540) ;;
    110000) dm=(960x540 960x540 960x1080 640x1080 640x1080 640x1080) ;;
    110011) dm=(960x540 960x540 960x1080 960x1080 960x540 960x540) ;;
    110110) dm=(960x540 960x540 960x1080 960x540 960x540 960x1080) ;;
    0000110)
      dm=(640x1080 640x1080 640x1080 640x1080 640x540 640x540 640x1080)
    ;;
    11111111)
      dm=(960x540 960x540 960x540 960x540 960x540 960x540 960x540 960x540)
    ;;
    *)
      echo cannot automatically set dimensions
      exit
    ;;
  esac
fi

# extent must come after resize
go=0
while [ "$go" -lt "$#" ]
do
  xc convert -quality 100 \
  ${sv+-shave $sv} \
  ${eg[go]:+-crop ${eg[go]}} \
  ${rz[go]:+-resize ${dm[go]}^} \
  -extent ${dm[go]} \
  -gravity ${gv[go]:-center} \
  {,=}"${sc[go]}"
  go=$((go+1))
done

# combine
${dry+exit}
# this needs to be here otherwise you are measuring the wrong height
ht=$(identify -format '%h\n' "$@" | mn)

set =*
case $ao in
000011) xc convert "$1" "$2" "$3" "$4" '(' "$5" "$6" -append ')' +append \
  -quality 100 "$ao" ;;
000110) xc convert "$1" "$2" "$3" '(' "$4" "$5" -append ')' "$6" +append \
  -quality 100 "$ao" ;;
011011) xc convert "$1" '(' "$2" "$3" -append ')' "$4" \
  '(' "$5" "$6" -append ')' +append -quality 100 "$ao" ;;
110000) xc convert '(' "$1" "$2" -append ')' "$3" "$4" "$5" "$6" +append \
  -quality 100 "$ao" ;;
110011) xc convert '(' "$1" "$2" -append ')' "$3" "$4" \
  '(' "$5" "$6" -append ')' +append -quality 100 "$ao" ;;
110110) xc convert '(' "$1" "$2" -append ')' "$3" \
  '(' "$4" "$5" -append ')' "$6" +append -quality 100 "$ao" ;;
0000110) xc convert "$1" "$2" "$3" "$4" \
  '(' "$5" "$6" -append ')' "$7" +append -quality 100 "$ao" ;;
11111111) xc convert '(' "$1" "$2" -append ')' '(' "$3" "$4" -append ')' \
  '(' "$5" "$6" -append ')' '(' "$7" "$8" -append ')' +append \
  -quality 100 "$ao" ;;
*) xc convert "$@" +append -quality 100 "$ao" ;;
esac

sn=$(basename ~+)
xc mv "$ao" "s $sn h $ht".jpg
xc rm "$@"
