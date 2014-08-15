# A mosaic in digital imaging is a plurality of non-overlapping images, arranged
# in some tessellation.
function hr {
  sed '
  1d
  $d
  s/  //
  ' <<< "$1"
}

type magick >/dev/null || exit

if (( ! $# ))
then
  hr "
  ${0##*/} [-d] [-c crop] [-r resize] [-w width] [-s shave] [FILES]

  -d   dry run
       create pieces only

  -c   comma separated list of crops
       example   -300,0,+300,0

  -r   comma separated list of resize markers
       example   yes,yes,yes,no

  -w   comma separated list of widths
       example   1920,1280,960,640

  -s   how much to shave
       example   6x6
  "
  exit
fi

while getopts dc:r:w:s: name
do
  case $name in
  d) (( dry++ ))            ;;
  c) eg=(${OPTARG//,/ })    ;;
  r) rz=(${OPTARG//,/ })    ;;
  w) wd=(${OPTARG//,/ })    ;;
  s) shave="-shave $OPTARG" ;;
  esac
  ot+=$OPTARG
done
shift $((--OPTIND))

[[ $eg ]] || eg=(0 0 0 0 0 0)
[[ $rz ]] || rz=(yes yes yes yes yes yes)
[[ $wd ]] || case $(identify -format '%[fx:w/h>1]' "$@") in
  11) wd=(1920 1920) ;;
  0101) wd=(640 1280 640 1280) ;;
  0110) wd=(640 1280 1280 640) ;;
  1001) wd=(1280 640 640 1280) ;;
  1010) wd=(1280 640 1280 640) ;;
  1111) wd=(960 960 960 960) ;;
  0111) wd=(640 1280 960 960) ;;
  1011) wd=(1280 640 960 960) ;;
  1101) wd=(960 960 640 1280) ;;
  1110) wd=(960 960 1280 640) ;;
  00001) wd=(640 640 640 640 1280) ;;
  00010) wd=(640 640 640 1280 640) ;;
  01000) wd=(640 1280 640 640 640) ;;
  10000) wd=(1280 640 640 640 640) ;;
  00011) wd=(640 640 640 960 960) ;;
  11000) wd=(960 960 640 640 640) ;;
  000000) wd=(640 640 640 640 640 640) ;;
esac

ia=("$@")

# crop images
for ((o = 0; o < $#; o++))
do
  if [[ ${rz[o]} = yes ]]
  then
    resize="-resize ${wd[o]}x1080^"
  else
    resize=
  fi
  magick "${ia[o]}" $shave -crop ${eg[o]} $resize -gravity center \
    -extent ${wd[o]}x1080 -compress lossless ~"${ia[o]}"
done

# combine
(( dry )) && exit
magick ~*.jpg +append -compress lossless "outfile $ot".jpg
rm ~*.jpg
