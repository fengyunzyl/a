# A mosaic in digital imaging is a plurality of non-overlapping images, arranged
# in some tessellation.
type magick >/dev/null || exit

if (( ! $# ))
then
  echo ${0##*/} [-s shave] [-g gravity] FILES
  echo
  echo '-s   how much to shave from width and height'
  echo '     example   10x10'
  echo
  echo '-g   comma separated list of output gravities'
  echo '     example   center,center,north,east'
  exit
fi

if [[ $1 = -s ]]
then
  shave="-shave $2"
  shift 2
fi

if [[ $1 = -g ]]
then
  gv=(${2//,/ })
  shift 2
else
  gv=(center center center center center center)
fi

ia=("$@")

case $(identify -format '%[fx:w/h>1]' "$@") in
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

# crop images
for ((o = 0; o < $#; o++))
do
  magick "${ia[o]}" $shave \
    -resize ${wd[o]}x1080^ -gravity ${gv[o]} \
    -extent ${wd[o]}x1080 -compress lossless outfile-$o.jpg
done

# combine
magick outfile-*.jpg +append -compress lossless $(date +%s).jpg
rm outfile-*.jpg
