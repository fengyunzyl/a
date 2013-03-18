# Combine song with video
# As long as source video is "720p", that is to say 1280 width it should come
# out as 720p on YouTube, even if height is not quite 720.

# cut down video source. remove audio, metadata, and chapters
ffmpeg -ss 2:00:00 -i tt.mp4 -c copy \
  -map v -map_metadata -1 -map_chapters -1 uu.mp4

# mux video and audio with proper offset
ffmpeg -ss 593 -i uu.mp4 -i vv.flac -shortest -c:v copy \
  -c:a aac -strict -2 -b:a 495263 ww.mp4

# use ffvhuff, creates smaller files than huffyuv
# use nightly avidemux, save as ffvhuff precise cuts
ffmpeg -i precise.mkv -i audio.flac -crf 18 -c:a aac -strict -2 -b:a 495263 \
  -map v -map 1:a crf18.mp4
