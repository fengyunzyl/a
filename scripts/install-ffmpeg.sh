# zeranoe ffmpeg

wget ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-latest-win64-static.7z
P7ZIP="${ProgramW6432}/7-zip/7z"
"$P7ZIP" x ffmpeg-latest-win64-static.7z
cd ffmpeg-*-win64-static
cp -r bin /usr/local
