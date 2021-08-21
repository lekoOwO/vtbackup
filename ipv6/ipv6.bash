#!/bin/bash

DEV="eth0"
CIDR="64"

PREFIX="2001:0123:4567:89a"
SUFFIX="0"

isReboot="${1:-false}"

OUTPUT_FILE="/root/ipv6/address.txt"
if [ -f $OUTPUT_FILE ]; then
    echo "Deleting old IPv6 addresses..."
    OLD_SUFFIX=""
    while IFS= read -r line; do
        if [ ${#OLD_SUFFIX} -eq 0 ]; then
            sp=`echo $line | grep -oP '.+:\K.+?(?=::.+)'`
            OLD_SUFFIX=${sp: -1}
        fi
        ip a del "$line/$CIDR" dev $DEV
    done < "$OUTPUT_FILE"
    SUFFIX="$(((0x$OLD_SUFFIX + 1)%16))"
    SUFFIX=$(printf "%x\n" $SUFFIX)
fi
rm "$OUTPUT_FILE"
touch "$OUTPUT_FILE"

X_PREFIX="${PREFIX}${SUFFIX}::"
for (( num=1; num <= 0xff; num+=1 )); do
    suffix=$(printf "%x\n" $num)
    ip="${X_PREFIX}${suffix}"    

    ip addr add "$ip/$CIDR" dev $DEV
    echo "$ip" >> "$OUTPUT_FILE"
done