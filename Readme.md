# vtbackup

This project contains all scripts you need to automatically grab live streams from several channels.

Highlights:

1. Auto download live streams when it starts

2. Callback function. Allowing to upload to GDrive, OneDrive...(rclone supported) after videos are downloaded.

3. Address Pool to prevent HTTP 429 error from Youtube.

4. Using a light-weight Alpine Linux!

5. Telegram notification

6. Monitored channels are easy to be added

## Requirements

- Alpine Linux
- a IPv6 prefix (optional, strongly recommended)
- a large enough Cloud Drive (optional, recommended)
- Telegram bot token (optional)

## Installation

Run `git clone --recursive https://github.com/lekoOwO/vtbackup .` on `/root`

## Init

Install all dependencies by running `sh /root/scripts/live-dl.init.sh`.

## Config

### 1. Config live-dl

Config live-dl with its example config file.

### 2. IPv6 Pool

It's recommended to config a IPv6 Pool to prevent Youtube HTTP 429 error.

Make sure that you are in a SLAAC (IPv6 stateless) environment.

#### 2.a Config script

fill `PREFIX`, `DEV`, `CIDR` in `/root/ipv6/ipv6.bash` and make it executable.

It's using `${PREFIX}${SUFFIX}::1` to `${PREFIX}${SUFFIX}::ff` by default, change it if you want (just modify the for-loop part, easy.)

#### 2.b Config live-dl

```
address_pool: true
address_pool_file: /root/ipv6/address.txt
```

### 3. Callback

#### 3.a Config live-dl

```
run_callback: true
callback:
  executable: /root/scripts/callback.bash
```

#### 3.b1 Using lekoOwO's script

Download rclone and config your storage.

A example callback file is provided, modify it to meet your need :D

Downloaded video will be uploaded to your cloud storage and deleted locally.

#### 3.b2 Use your own solution

Write your own callback script, yay!

`EXECUTABLE "${OUTPUT_PATH}.mp4" "$BASE_DIR/" $VIDEO_ID $FULLTITLE $UPLOADER $UPLOAD_DATE` will be called after the video is downloaded.

Save your callback script to `/root/scripts/callback.bash` and make it executable.

### 4. YTArchive

[YTArchive](https://github.com/Kethsar/ytarchive) is a convinient script to archive youtube videos.

`config.yml`
```
use_ytarchive: true
ytarchive:
    executable: YTARCHIVE_PY_LOCATION
    cookie: YOUR_COOKIE_TXT
```

### 5. Telegram Notification

This part helps you to know whether you are 429ed by receiving messages on a telegram channel every x minutes.

#### 5.a isBanned.bash

Fill your `CHANNEL_ID`, `CHAT_ID`, `BOT_TOKEN` in.

#### 5.b Make it run every 15 minutes

```
cd /etc/periodic/15min/
ln /root/scripts/isBanned.bash
mv ./isBanned.bash ./isBanned
chmod +x ./isBanned
```

##### 4.b.1 Enable crontab
`rc-service crond start && rc-update add crond default`

### 6. Startup script 

Look at `start.bash.example`.

Make it executable.

#### 6.a Make in run at boot

```
rc-update add local default
cd /etc/local.d/
ln /root/start.bash
mv ./start.bash ./live-dl.start
chmod +x ./live-dl.start
```

### 7. Add monitored channel

`add_channel.sh` is a convinient script to add a monitored channel!

Don't forget to edit it (`DEFAULT_TELEGRAM_CHANNEL_ID`)!