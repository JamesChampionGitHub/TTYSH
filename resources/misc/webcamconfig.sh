#!/bin/bash

#settings for webcam
sudo v4l2-ctl -d /dev/video0 --set-ctrl=power_line_frequency=1
sudo v4l2-ctl -d /dev/video1 --set-ctrl=power_line_frequency=1
sudo v4l2-ctl -d /dev/video2 --set-ctrl=power_line_frequency=1


#	if [[ $TERM = "linux" ]]; then
#	    sudo ffmpeg -f fbdev -framerate 30 -i /dev/fb0 ttyrecord"$(date +%S%M%H%d%m%Y)".mp4 &
#	elif [[ $TERM = "xterm-256color" ]]; then
#		ffmpeg -video_size 1280x800 -framerate 30 -f x11grab -i :0 x11record"$(date +%S%M%H%d%m%Y)".mp4 &
#	elif [[ $TERM = "foot" ]]; then
#		wf-recorder -r 30 -F "scale=1280:800" -f swayrecord"$(date +%S%M%H%d%m%Y)".mp4 &
#	fi

ffmpeg -f v4l2 -video_size 1280x720 -i /dev/video2 -f alsa -i default -c:v libx264 -preset ultrafast -c:a aac webcam.mp4


#unused below:
#ffmpeg -video_size 1280x800 -framerate 30 -f x11grab -i :0 x11record.mp4 &

#ffmpeg -f alsa -ac 1 -i hw:0 -f video4linux2 -i /dev/video0 /tmp/out.mpg
#ffmpeg -f alsa -ac 1 -i hw:0 -f video4linux2 -i /dev/video0 -framerate 30 /tmp/out1.mpg

