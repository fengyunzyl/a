function warn {
  printf '\e[36m%s\e[m\n' "$*"
}

function log {
  unset PS4
  sx=$((set -x
    : "$@") 2>&1)
  warn "${sx:2}"
  "$@"
}

function hx {
  printf 0x%04x%04x $*
}

function bf {
  regtool set /user/console/ScreenBufferSize $(hx 2000 $1)
  regtool set /user/console/WindowSize       $(hx   22 $1)
  cygstart bash $2
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
wget -q rawgit.com/FFmpeg/FFmpeg/master/libswresample/options.c || exit
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
  "-map v"
  "-map :$c6"
  "-c:v copy"
  "-b:a 256k"
  "-ac 2"
  "-clev 3dB"
  "-slev -6dB"
  "-metadata 'comment=clev 3dB slev -6dB'"
)

case ${#c2}${#c6} in
01)
  ao+=("echo One 5.1 stream, use my downmix")
  ao+=("log ffmpeg ${ag[*]} mn-'$sc'")
;;
10)
  ao+=("echo One stereo stream, reject file")
;;
11)
  ao+=("echo Dual audio, use my downmix on 5.1 stream")
  ao+=("log ffmpeg ${ag[*]} mn-'$sc'")
;;
esac
ao+=("warn Press any key to continue . . .")
ao+=("read")
ao+=("rm rx.sh")
ao+=("bf 80")
printf '%s\n' "${ao[@]}" > rx.sh
export -f bf hx log warn
bf 88 rx.sh

# if i am going to be transcoding anyway, i might as well use ffmpeg for the
# volume too
# ffmpeg -i a.mkv -c:v copy -af volume=3dB -b:a 384k out.mp4
# ffmpeg -i infile -vn -af volumedetect -f null -
# ffmpeg -i infile -vn -filter_complex ebur128=peak=true -f null -
