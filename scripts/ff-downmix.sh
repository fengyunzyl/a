# clear dialogues with left and right channel music still being audible but more
# in the background
if (( $# != 1 ))
then
  echo ${0##*/} FILE
  exit
fi

ib=${1%.*}
ie=${1##*.}

ffmpeg -i "$1" -t 600 -sn -c:v copy -ac 2 -c:a libfdk_aac "$ib-downmix-ac.$ie"

gn=$(awk 'BEGIN{printf"%.7f",1/sqrt(2)}')
FL="FL < FC + $gn*FL + $gn*BL + $gn*SL"
FR="FR < FC + $gn*FR + $gn*BR + $gn*SR"
ffmpeg -i "$1" -t 600 -sn -c:v copy \
  -af "pan=stereo| $FL | $FR" -c:a libfdk_aac "$ib-downmix-af.$ie"
