#!/bin/sh
# Dont do H.264 because of B-frames
# ffmpeg -i d.flv -x264opts crf=0 -c:a copy -c:v h264 -g 1 -y e.flv

# Just use AviDemux 2.6.1 MP4v2 Muxer
