# set metadata with FFmpeg
# http://multimedia.cx/eggs/supplying-ffmpeg-with-metadata

ffmpeg -i maida.mp2 \
  -metadata TITLE='Obelisk' \
  -metadata ALBUM='2003-09-03: Maida Vale, London, UK' \
  -metadata ARTIST='The Mars Volta' \
  -metadata LABEL='' \
  -metadata DATE='2003' \
  maida.flac
