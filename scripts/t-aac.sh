# test ffmpeg aac encoder
# 498795

usage ()
{
  echo usage: $0 BITRATE
  exit
}

[ $1 ] || usage
arg_rate=$1
arg_dir=$HOMEDRIVE/steven/music/autechre

timeout 10 ffmpeg \
  -i $arg_dir/exai/Exai-001-Autechre-Fleure.flac \
  -c:a aac -strict -2 -v warning -stats -cutoff 17000 -map a -t 10 \
  -b:a $arg_rate -y fleure.m4a

[ $? = 0 ] || exit

timeout 10 ffmpeg \
  -i $arg_dir/incunabula-flac/Incunabula-009-Autechre-Windwind.flac \
  -c:a aac -strict -2 -v warning -stats -cutoff 17000 -map a -t 10 \
  -ss 00:03:00 -b:a $arg_rate -y wind.m4a

[ $? = 0 ] || exit

timeout 10 ffmpeg \
  -i $arg_dir/oversteps/Oversteps-014-Autechre-Yuop.flac \
  -c:a aac -strict -2 -v warning -stats -cutoff 17000 -map a -t 10 \
  -ss 00:03:10 -b:a $arg_rate -y yuop.m4a
