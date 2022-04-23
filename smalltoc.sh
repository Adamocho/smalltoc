#!/bin/sh

before=2

printf "## Table of content\n"

while read -r line
do
    line=$(echo "$line" | grep -E "#{2,}[[:space:]][[:alnum:]]")
    after=$(echo "$line" | cut -d ' ' -f 1 | tr -d "[:space:]" | wc -m)

    [ -z "$line" ] && continue

    text=$(echo "$line" | cut -d ' ' -f 1 --complement)
    link=$(echo "$text" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')

    {
        i=2
        while [ $i -lt "$after" ]; do
            printf "%b" "\t"

            i=$((i + 1))
        done
        printf "%s [%s](#%s)\n" "-" "$text" "$link"
    }
done