# Bash download from YouTube
# http://youtube.com/watch?v=LHelEIJVxiE
# http://youtube.com/watch?v=blnCm0YX4ls

if [[ $OSTYPE =~ linux ]]
then
  FIREFOX ()
  {
    firefox $1
  }
else
  FIREFOX ()
  {
    cmd.exe /c "start firefox \"$1\""
  }
fi

qual=(
  [5]='240p FLV h.263'
  [17]='144p 3GP mpeg4 simple'
  [18]='360p MP4 h.264 baseline'
  [22]='720p MP4 h.264 high'
  [34]='360p FLV h.264 main'
  [35]='480p FLV h.264 main'
  [36]='240p 3GP mpeg4 simple'
  [37]='1080p MP4 h.264 high'
  [43]='360p WebM vp8'
  [44]='480p WebM vp8'
  [45]='720p WebM vp8'
  [46]='1080p WebM vp8'
  [82]='360p MP4 h.264 3D'
  [84]='720p MP4 h.264 3D'
  [100]='360p WebM vp8 3D'
  [102]='720p WebM vp8 3D'
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
  qq=$((set -x; : "$@") 2>&1)
  warn "${qq:2}"
  eval "${qq:2}"
}

[ $1 ] || usage
[ $2 ] || set '' $1
arg_itag=$1
arg_url=$2
declare $(awk NF=NF FPAT='[^&?]*=[^&]*' <<< $arg_url)
declare $(curl -s www.youtube.com/get_video_info?video_id=$v | sed 'y/&/ /')
set $(decode url_encoded_fmt_stream_map | sed 'y/,/ /')

for oo
do
  declare $(sed 'y/&/ /' <<< $oo)
  if ! [ $arg_itag ]
  then
    printf ' %3.3s  %s\n' $itag "${qual[itag]}"
  elif [ $arg_itag = $itag ]
  then
    break
  fi
done

[ $arg_itag ] || usage
FIREFOX `decode url`"&signature=$sig"
