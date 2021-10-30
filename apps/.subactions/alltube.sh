#!/usr/bin/with-contenv bash
# shellcheck shell=bash
#FUNCTIONS

basefolder="/opt/appdata"
typed=alltube

if [[ ! -f "$basefolder/${typed}/config.json" ]];then

cat <<'EOF' > $basefolder/${typed}/config.json
#####################################
# All rights reserved.              #
# started from Zero                 #
# Docker owned dockserver           #
# Docker Maintainer dockserver      #
#####################################
#####################################
# THIS DOCKER IS UNDER LICENSE      #
# NO CUSTOMIZING IS ALLOWED         #
# NO REBRANDING IS ALLOWED          #
# NO CODE MIRRORING IS ALLOWED      #
#####################################
---
# Path to your youtube-dl binary
youtubedl: vendor/rg3/youtube-dl/youtube_dl/__main__.py

# Path to your python binary
python: /usr/bin/python

# An array of parameters to pass to youtube-dl
params:
    - --no-warnings
    - --ignore-errors
    - --flat-playlist
    - --restrict-filenames

# True to enable audio conversion
convert: false

# True to enable advanced conversion mode
convertAdvanced: false

# List of formats available in advanced conversion mode
convertAdvancedFormats: [mp3, avi, flv, wav]

# Path to your avconv or ffmpeg binary
avconv: vendor/bin/ffmpeg

# avconv/ffmpeg logging level.
avconvVerbosity: error

# Path to the directory that contains the phantomjs binary.
phantomjsDir: vendor/bin/

# True to disable URL rewriting
uglyUrls: false

# True to stream videos through server
stream: false

# MP3 bitrate when converting (in kbit/s)
audioBitrate: 128
#EOF
EOF
fi

