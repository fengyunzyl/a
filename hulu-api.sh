#!/bin/sh
# Hulu API

# get episode position
set 'video_id=441295'
curl "www.hulu.com/api/2.0/video_position_in_show?$1"

# get episode info
set 'show_id=12867&position=107&items_per_page=1'
curl "www.hulu.com/api/2.0/videos.json?$1"

# api/2.0/info/video.json
# api/2.0/shows.json
# api/2.0/videos
# api/2.0/info/show.json
# api/2.0/featured.json
# api/2.0/video_game.json
# api/2.0/video_games.json
# api/2.0/criterions.json
# api/2.0/favorited_show_ids
# api/2.0/queued_video_ids
# api/2.0/trailers.json
# api/2.0/plus_upsell.json
# api/2.0/companies.json
