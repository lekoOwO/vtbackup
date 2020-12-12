#!/bin/bash
CHANNEL_ID="" # A random youtube channel id.
ADDRESS_POOL="/root/ipv6/address.txt"
CHAT_ID="" # Telegram Chat ID used to preserve logs.
BOT_TOKEN="" # Telegram Bot token.

ip=$(shuf -n 1 "${ADDRESS_POOL}")

USER_AGENT="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36"

result=`curl -sIL -X GET --compressed -H "User-Agent: $USER_AGENT" --interface $ip "https://www.youtube.com/channel/$CHANNEL_ID/live" | tac | tac | head -n 1 | grep -o '\d\d\d'`

# Send to Telegram
if [ "$result" != "200" ]; then
  status="BANNED - $result"
  disable_notification="false"
else
  status="OK"
  disable_notification="true"
fi

tg_type="sendMessage"
tg_body='{
    "chat_id": "'"$CHAT_ID"'",
    "text": "IP Status: '"$status"'\nIP: \`'"$ip"'\`",
    "disable_notification": '"$disable_notification"',
    "parse_mode": "Markdown"
  }'

curl -s -X POST -H 'Content-Type: application/json' -d "$tg_body" "https://api.telegram.org/bot$BOT_TOKEN/$tg_type" > /dev/null