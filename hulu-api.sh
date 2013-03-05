#!/bin/sh
# Hulu API

# get video position
set 'video_id=441295'
curl "www.hulu.com/api/2.0/video_position_in_show?$1"

# get info for multiple videos
set 'show_id=12867&position=107&items_per_page=1'
curl "www.hulu.com/api/2.0/videos.json?$1"

# get video info
curl 'www.hulu.com/api/2.0/video?id=441362'
