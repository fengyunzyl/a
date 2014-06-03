warn () {
  printf '\e[36m%s\e[m\n' "$*"
}

log () {
  unset PS4
  sx=$((set -x
    : "$@") 2>&1)
  warn "${sx:2}"
  "$@"
}

buffer () {
  powershell '&{
  sp hkcu:console ScreenBufferSize ("0x{0:x}{1:x4}" -f 2000,$args[0])
  sp hkcu:console WindowSize       ("0x{0:x}{1:x4}" -f   25,$args[0])
  }' $(( ${#1} ? 88 : 80 ))
  cygstart bash $1
  kill -7 $$ $PPID
}

if (( $# != 1 ))
then
  echo ${0##*/} FILE
  exit
fi
sc=$1

# lets split out the good downmix, because that might be a while
echo Checking downmix
wget -q https://raw.githubusercontent.com/FFmpeg/FFmpeg/master/libswresample\
/swresample.c
(( $? )) && exit
awk '/center_mix_level/ && /C_30DB/ {exit 1}' swresample.c
bad=$?
rm swresample.c
if (( ! bad ))
then
  warn Good downmix available, fix script
  exit
fi

# get streams
ffprobe -v 0 -of csv -show_streams "$sc" > streams.csv
c2=$(awk '/stereo/,$0=$2' FS=, streams.csv)
c6=$(awk '/5\.1/,$0=$2' FS=, streams.csv)
rm streams.csv

ag=(
  "-hide_banner"
  "-i '$sc'"
  "-c:v copy"
  "-b:a 256k"
  "-ac 2"
  "-clev 3dB"
  "-slev -6dB"
  "-metadata 'comment=clev 3dB slev -6dB'"
)

case ${#c2}${#c6} in
01)
  echo echo One 5.1 stream, use my downmix  
  echo log ffmpeg "${ag[@]}" mn-"$sc"
;;
10)
  echo echo One stereo stream, reject file
;;
11)
  echo echo Dual audio, use my downmix on 5.1 stream
  echo log ffmpeg "${ag[@]}" -map v -map :$c6 mn-"$sc"
;;
esac > rx.sh
echo '
warn Press any key to continue . . .
read
rm rx.sh
buffer
' >> rx.sh
export -f buffer log warn
buffer rx.sh

# final step is check the gain
