# A mosaic in digital imaging is a plurality of non-overlapping images, arranged
# in some tessellation.
type magick >/dev/null || exit

if (( ! $# ))
then
  echo ${0##*/} [-s shave] [-r resize] [-w width] [-c crop] FILES
  echo
  echo '-s   how much to shave'
  echo '     example   6x6'
  echo
  echo '-r   comma separated list of resize markers'
  echo '     example   yes,yes,yes,no'
  echo
  echo '-w   comma separated list of widths'
  echo '     example   640,1280,960,960'
  echo
  echo '-c   comma separated list of crops'
  echo '     example   -300,0,+300,0'
  exit
fi

while [[ ${1::1} == - ]]
do
  case $1 in
  -s) shave="-shave $2" ;;
  -r) rz=(${2//,/ }) ;;
  -w) wd=(${2//,/ }) ;;
  -c) eg=(${2//,/ }) ;;
  esac
  ot+=$2
  shift 2
done

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
    -extent ${wd[o]}x1080 -compress lossless inter-$o.jpg
done

# combine
magick inter-*.jpg +append -compress lossless "outfile $ot".jpg
rm inter-*.jpg
