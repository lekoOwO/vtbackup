#!/bin/bash
CHANNEL_ID="" # A random youtube channel id.
ADDRESS_POOL="/root/ipv6/address.txt"
CHAT_ID="" # Telegram Chat ID used to preserve logs.
BOT_TOKEN="" # Telegram Bot token.

ip=$(shuf -n 1 "${ADDRESS_POOL}")

result=`curl -sI --interface $ip "https://www.youtube.com/channel/$CHANNEL_ID/live" | tac | tac | head -n 1`
result=($result)
result=${result[1]} # HTTP Status Code

# Send to Telegram
if [ "$result" != "200" ]; then
  status="BANNED"
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