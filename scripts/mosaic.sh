# A mosaic in digital imaging is a plurality of non-overlapping images, arranged
# in some tessellation.

usage ()
{
  echo usage: ${0/*\/} FILES
  exit
}

(( $# )) || usage

# option order matters
convert \
  -resize x1080 \
  -crop 640x1080+0+0 \
  -gravity center \
  +append \
  $* $(date +%s).png
