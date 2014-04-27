# A mosaic in digital imaging is a plurality of non-overlapping images, arranged
# in some tessellation.
type magick >/dev/null || exit

if (( $# < 3 ))
then
  echo ${0##*/} [-shave WxH] WIDTHS GRAVITIES FILES
  echo
  echo 'WIDTHS     comma separated list of output widths'
  echo '           example  640,1280,960,960'
  echo
  echo 'GRAVITIES  comma separated list of output gravities'
  echo '           example  center,center,north,east'
  exit
fi

if [[ $1 = -shave ]]
then
  shave="-shave $2"
  shift 2
fi

# crop images
wd=(${1//,/ })
shift
gv=(${1//,/ })
shift
ia=("$@")

for ((o = 0; o < $#; o++))
do
  magick "${ia[o]}" $shave \
    -resize ${wd[o]}x1080^ -gravity ${gv[o]} \
    -extent ${wd[o]}x1080 outfile-$o.png
done

# combine
magick outfile-*.png +append $(date +%s).png
