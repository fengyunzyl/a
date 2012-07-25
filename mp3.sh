#!/bin/bash
# Batch encode mp3

while read; do
  ffmpeg \
    -i "$REPLY" \
    -b:a 320k \
    -id3v2_version 3 \
    "${REPLY%.*}.mp3" \
    </dev/null
done < <(find -name '*.wav')
