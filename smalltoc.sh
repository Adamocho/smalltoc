#!/bin/sh

INSTALL_PATH="/usr/bin/smalltoc"

generate_toc() {
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
}

case $1 in
    '')
        generate_toc
        ;;
    'install' | 'add')
        (set -x; sudo cp "$0" $INSTALL_PATH)
        ;;
    'uninstall' | 'remove')
        (set -x; sudo rm -i $INSTALL_PATH)
        ;;
    '-h' | '--help')
        echo "smalltoc - Lightweight Table of content genrator
        Usage:
            smalltoc [Options]

            NOTE: The script is meant to read from pipe!

            OPTIONS

            install/add - add script to \$PATH

            uninstall/remove - remove script from \$PATH

            -h/--help - show help"
        ;;
    *)
        echo "Wrong arguments given: $1"
        ;;
esac