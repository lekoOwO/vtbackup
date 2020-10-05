#!/bin/bash

# Example: PREFIX="2001:ffff:ffff:ffff:ffff::"
PREFIX=""
OUTPUT_FILE="/root/ipv6/address.txt"

rm "$OUTPUT_FILE"
touch "$OUTPUT_FILE"

for (( num=1; num <= 0xfff; num+=1 )); do
    suffix=$(printf "%x\n" $num)
    ip="${PREFIX}${suffix}"    

    ip addr add "$ip/64" dev eth0
    echo "$ip" >> "$OUTPUT_FILE"
done