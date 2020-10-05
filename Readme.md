# vtbackup

This project contains all scripts you need to automatically grab live streams from several channels.

## Requirements

- Alpine Linux
- a IPv6 prefix (optional, strongly recommended)
- a large enough Cloud Drive (optional, recommended)
- Telegram bot token (optional)

## Installation

Run `git clone --recursive https://github.com/lekoOwO/vtbackup .` on `/root`

## Init

Install all dependencies by running `sh /root/init.sh`.

## Config

### Config live-dl

Config live-dl.
My config is put at `/root/example/config.example.yml` for reference.
Confidential info is masked with `*`

### IPv6 Pool

It's recommended to config a IPv6 Pool to prevent Youtube HTTP 429 error.

Make sure that you are in a SLAAC (IPv6 stateless) environment.

#### Config script

fill prefix in `/root/ipv6/ipv6.bash` and make it executable.

It's using `${PREFIX}::1` to `${PREFIX}::fff` by default, change it if you want (just modify the for-loop part, easy.)

#### Config live-dl

`address_pool: true` and `address_pool_file: /root/ipv6/address.txt`

### Callback

##### Config live-dl

```
run_callback: true
callback:
  executable: /root/callback
```

#### A. Using lekoOwO's script

##### Init

Download rclone and config your storage as `vtuber:/`

move `/root/example/callback.bash.example` to `/root/callback` and make it executable.

Downloaded video will be uploaded to your cloud storage and deleted locally.

#### B. Use your own solution

Write your own callback script, yay!

`EXECUTABLE "${OUTPUT_PATH}.mp4" "$BASE_DIR/" $VIDEO_ID $FULLTITLE $UPLOADER $UPLOAD_DATE` will be called after the video is downloaded.

Save your callback script to `/root/callback` and make it executable.

### Telegram Notification

This part helps you to know whether you are 429ed by receiving messages on a telegram channel every 15 minutes.

#### isBanned.bash

Fill your `CHANNEL_ID`, `CHAT_ID`, `BOT_TOKEN` in.

#### Make it run every 15 minutes

```
cd /etc/periodic/15min/
ln /root/isBanned.bash
mv ./isBanned.bash ./isBanned
chmod +x ./isBanned
```

##### Enable crontab
`rc-service crond start && rc-update add crond default`

### Startup script 

remove L3 (The IPv6 line) from `/root/start.bash` if you didn't use IPv6 Pool.

Make it executable.

#### Make in run at boot

```
rc-update add local default
cd /etc/local.d/
ln /root/start.bash
mv ./start.bash ./live-dl.start
chmod +x ./live-dl.start
```