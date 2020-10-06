#!/bin/sh
apk add --no-cache aria2 bash ffmpeg python3 perl build-base curl jq git nano exiv2-dev coreutils
apk add exiv2 --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community
pip3 install streamlink youtube-dl yq