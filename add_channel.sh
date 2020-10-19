#!/bin/sh
DEFAULT_TELEGRAM_CHANNEL_ID="YOUR_TELEGRAM_ID"

read -p 'Channel Name: ' name
read -p 'Channel ID: ' channel_id
read -p 'Telegram Chat ID: ' prompt_telegram_id

TELEGRAM_ID="${prompt_telegram_id:-${DEFAULT_TELEGRAM_CHANNEL_ID}}"

sed -i "/CHANNEL_IDS=(/a \\ \\ [\"$name\"]=\"$channel_id\"" /root/start.bash

cat >> /root/live-dl/config.yml <<EOL

  - name: ${name}
    youtube: https://www.youtube.com/channel/${channel_id}
    telegram: ${TELEGRAM_ID}
EOL

echo "Reboot your machine to make it take effect!"
