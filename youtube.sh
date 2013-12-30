# Bash download from YouTube
# http://youtube.com/watch?v=LHelEIJVxiE
# http://youtube.com/watch?v=blnCm0YX4ls

if [[ $OSTYPE =~ linux ]]
then
  XDG_OPEN=xdg-open
else
  XDG_OPEN='cmd /c start ""'
fi

qual=(
  [5]='240p FLV h.263'
  [17]='144p 3GP mpeg4'
  [18]='360p MP4 h.264'
  [22]='720p MP4 h.264'
  [34]='360p FLV h.264'
  [35]='480p FLV h.264'
  [36]='240p 3GP mpeg4'
  [37]='1080p MP4 h.264'
  [43]='360p WebM vp8'
  [44]='480p WebM vp8'
  [45]='720p WebM vp8'
  [46]='1080p WebM vp8'
  [82]='360p MP4 3D'
  [84]='720p MP4 3D'
  [100]='360p WebM 3D'
  [102]='720p WebM 3D'
)

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

usage ()
{
  echo usage
  echo $0 URL
  echo or
  echo $0 ITAG URL
  exit
}

decode ()
{
  sed 's % \\\\x g' <<< ${!1} | xargs printf
}

log ()
{
  unset PS4
  qq=$(( set -x
         : "$@" )2>&1)
  warn "${qq:2}"
  eval "${qq:2}"
}

case $# in
  0) usage     ;;
  1) set '' $1 ;;
esac

arg_itag=$1
arg_url=$2
v=$arg_url
declare -l $(awk NF=NF FPAT='[^&?]*=[^&]*' <<< $arg_url)
declare $(curl -s www.youtube.com/get_video_info?video_id=$v | sed 'y/&/ /')
set $(decode url_encoded_fmt_stream_map | sed 'y/,/ /')

for oo
do
  declare $(sed 'y/&/ /' <<< $oo)
  case $arg_itag in
       '') printf ' %3.3s  %s\n' $itag "${qual[itag]}" ;;
    $itag) break                                       ;;
  esac
done

[ $arg_itag ] || usage
$XDG_OPEN "$(decode url)&signature=$sig&title=videoplayback "
