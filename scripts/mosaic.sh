# A mosaic in digital imaging is a plurality of non-overlapping images, arranged
# in some tessellation.

if (( ! $# ))
then
  echo ${0##*/} FILES
  exit
fi

# option order matters
type magick >/dev/null || exit

magick \
  "$@" \
  -resize x1080 \
  -gravity center \
  -extent '%[fx: w>h ? 1280 : 640]' \
  +append \
  $(date +%s).png
