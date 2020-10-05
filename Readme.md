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

Install all dependencies by running `sh /root/init.sh`.

## Config

### 1. Config live-dl

Config live-dl.

My config is put at `/root/example/config.example.yml` for reference.

Confidential info is masked with `*`

### 2. IPv6 Pool

It's recommended to config a IPv6 Pool to prevent Youtube HTTP 429 error.

Make sure that you are in a SLAAC (IPv6 stateless) environment.

#### 2.a Config script

fill prefix in `/root/ipv6/ipv6.bash` and make it executable.

It's using `${PREFIX}::1` to `${PREFIX}::fff` by default, change it if you want (just modify the for-loop part, easy.)

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
  executable: /root/callback
```

#### 3.b1 Using lekoOwO's script

Download rclone and config your storage as `vtuber:/`

move `/root/example/callback.bash.example` to `/root/callback` and make it executable.

Downloaded video will be uploaded to your cloud storage and deleted locally.

#### 3.b2 Use your own solution

Write your own callback script, yay!

`EXECUTABLE "${OUTPUT_PATH}.mp4" "$BASE_DIR/" $VIDEO_ID $FULLTITLE $UPLOADER $UPLOAD_DATE` will be called after the video is downloaded.

Save your callback script to `/root/callback` and make it executable.

### 4. Telegram Notification

This part helps you to know whether you are 429ed by receiving messages on a telegram channel every 15 minutes.

#### 4.a isBanned.bash

Fill your `CHANNEL_ID`, `CHAT_ID`, `BOT_TOKEN` in.

#### 4.b Make it run every 15 minutes

```
cd /etc/periodic/15min/
ln /root/isBanned.bash
mv ./isBanned.bash ./isBanned
chmod +x ./isBanned
```

##### 4.b.1 Enable crontab
`rc-service crond start && rc-update add crond default`

### 5. Startup script 

remove L3 (The IPv6 line) from `/root/start.bash` if you didn't use IPv6 Pool.

Make it executable.

#### 5.a Make in run at boot

```
rc-update add local default
cd /etc/local.d/
ln /root/start.bash
mv ./start.bash ./live-dl.start
chmod +x ./live-dl.start
```