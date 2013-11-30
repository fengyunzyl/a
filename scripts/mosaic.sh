# A mosaic in digital imaging is a plurality of non-overlapping images, arranged
# in some tessellation.

usage ()
{
  echo usage: ${0/*\/} FILES
  exit
}

(( $# )) || usage

# option order matters
ow='w>h ? 1280 : 640'

convert \
  -resize x1080 \
  -set option:distort:viewport "%[fx: $ow]x+%[fx: ow = $ow; (w-ow)/2]+0" \
  -distort SRT 0 \
  +append \
  $* $(date +%s).png
