# fix audio stream using FFmpeg
function hr {
  sed '
  1d
  $d
  s/  //
  ' <<< "$1"
}

if (( ! $# ))
then
  hr "
  ${0##*/} FILES

  Apply max noclip gain
  "
  exit
fi

for each
do
  case ${each: -3} in
  m4a)
    aacgain -k -r -s s -m 10 "$each"
  ;;
  mp3)
    mp3gain -k -r -s s -m 10 "$each"
  ;;
  esac
  echo
done
