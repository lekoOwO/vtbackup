#!/bin/sh
apk add --no-cache aria2 bash ffmpeg python3 py3-pip perl build-base curl jq git nano exiv2-dev coreutils grep
apk add exiv2 --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community
apk add --no-cache atomicparsley --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing
pip3 install streamlink youtube-dlc yq
