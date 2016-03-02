#!/bin/dash
# split album flac file
# FIXME Invalid duration specification for to: 80:00.000
# FIXME write metadata
# FIXME print seek times
# FIXME track number in file name

if [ $# != 1 ]
then
  echo 'ff-split.sh [cue file]'
  exit
fi

awk '
$1 == "FILE" {
  split($0, i, /"/)
  infile = i[2]
}
$1 == "TITLE" && infile {
  split($0, i, /"/)
  outfile[++j] = i[2]
}
$1 == "INDEX" && $2 {
  split($3, i, ":")
  start[j] = sprintf("%d:%02d:%06.3f", i[1]/60, i[1]%60, i[2]+i[3]/75)
}
END {
  for (each in outfile) {
    print infile
    print outfile[each] ".m4a"
    print start[each]
    print each == j ? "80:00.000" : start[each+1]
  }
}
' "$1" |
while
  read infile
  read outfile
  read start
  read stop
do
  ffmpeg -nostdin -hide_banner -i "$infile" -ss $start -to $stop \
    -map_metadata -1 -b:a 256k -movflags faststart "$outfile"
done
