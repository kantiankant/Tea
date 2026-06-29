#!/usr/bin/env bash

DB="orders.db"

touch "$DB"

generate_order_id() {
    while :; do
        id=$(
            printf "%s" "$(date +%s%N)$RANDOM$$" |
            sha256sum |
            cut -c1-8 |
            xargs printf "%d\n" 0x |
            awk '{printf "%06d", $1 % 1000000}'
        )

        if ! grep -q "^$id|" "$DB"; then
            echo "$id"
            return
        fi
    done
}

read -rp "Drink: " drink
read -rp "Size: " size
read -rp "Sugar: " sugar
read -rp "Ice: " ice
read -rp "Pearls (y/n): " pearls

order_id=$(generate_order_id)

printf "%s|%s|%s|%s|%s|%s\n" \
    "$order_id" \
    "$drink" \
    "$size" \
    "$sugar" \
    "$ice" \
    "$pearls" >> "$DB"

echo
echo "Order accepted."
echo "Order Number: $order_id"
