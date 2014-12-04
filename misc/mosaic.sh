# A mosaic in digital imaging is a plurality of non-overlapping images, arranged
# in some tessellation.
function hr {
  sed '
  1d
  $d
  s/  //
  ' <<< "$1"
}

type convert | grep -q bin || exit

if [ $# = 0 ]
then
  hr '
  mosaic.sh [options] [files]

  -d          dry run, create pieces only

  -s shave    how much to shave
              example  6x6

  -c crop     comma separated list of crops
              example  -300,0,+300,0

  -g gravity  comma separated list of gravities
              example  north,south,east,southeast

  -r resize   comma separated list of resize markers
              example  yes,yes,yes,no

  -w width    comma separated list of widths
              example  1920,1280,960,640
  '
  exit
fi

while getopts ds:c:g:r:w: name
do
  case $name in
  d) (( dry++ )) ;;
  s) sv=$OPTARG ;;
  c) IFS=, read -a eg <<< $OPTARG ;;
  g) IFS=, read -a gv <<< $OPTARG ;;
  r) IFS=, read -a rz <<< "${OPTARG//no}" ;;
  w) IFS=, read -a dm <<< $OPTARG ;;
  esac
  ot+=$OPTARG
done
shift $((--OPTIND))

[[ $dm ]] || case $(identify -format '%[fx:w/h>1]' "$@") in
  11) dm=({1920,1920}x1080) ;;
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
  ????????????) dm=({400,760,760,400,760,760,400,760,760,400,760,760}x540) ;;
esac

sc=("$@")

# crop images
for ((o=0; o<$#; o++))
do
  convert \
  ${sv+-shave $sv} \
  ${eg[o]+-crop ${eg[o]}} \
  ${gv[o]+-gravity ${gv[o]}} \
  ${rz[o]+-resize ${dm[o]}^} \
  -extent ${dm[o]} \
  -compress lossless \
  {,~}"${sc[o]}"
done

# combine
(( dry )) && exit
montage \
-tile x$(( $# / 7 + 1 )) \
-geometry -0 \
-compress lossless \
~* "outfile $ot".jpg
rm ~*
