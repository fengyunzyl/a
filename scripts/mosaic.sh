# A mosaic in digital imaging is a plurality of non-overlapping images, arranged
# in some tessellation.

if (( ! $# ))
then
  echo ${0##*/} FILES
  exit
fi

# option order matters
ow='w>h ? 1280 : 640'
type magick >/dev/null || exit

magick \
  "$@" \
  -resize x1080 \
  -crop "%[fx: $ow]x+%[fx: ow = $ow; (w-ow)/2]+0" \
  +append \
  $(date +%s).png
