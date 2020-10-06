#!/bin/bash

/root/ipv6/ipv6.bash

declare -A CHANNEL_IDS
CHANNEL_IDS=(
  ["Gawr Gura"]="UCoSrY_IQQVpmIRZ9Xf-y93g"
  ["Watson Amelia"]="UCyl1z3jo3XHR1riLFKG5UAg"
  ["Ninomae Ina'nis"]="UCMwGHR0BTZuLsmjY_NT5Pwg"
  # ["天使なの"]="UCxBmyZNQDFJVr9-ZE7hAYfA"
)

mkdir -p /tmp/live-dl

for key in "${!CHANNEL_IDS[@]}"; do
    /usr/bin/nohup /bin/bash /root/live-dl/live-dl "https://www.youtube.com/channel/${CHANNEL_IDS[${key}]}" &> "/tmp/live-dl/${key}.log" &
done