#!/bin/sh

INSTALL_PATH="/usr/bin/smalltoc"

generate_toc() {

    [ -e "$1" ] && printf "Generating TOC for %s:\n" "$1" && printf "## Table of content\n"

    while IFS= read -r line
    do
        line=$(echo "$line" | grep -E "#{2,}[[:space:]][[:alnum:]]")

        [ -z "$line" ] && continue

        text=$(echo "$line" | cut -d ' ' -f 1 --complement)
        link=$(echo "$text" | xargs | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
        num_tabs=$(echo "$line" | cut -d ' ' -f 1 | tr -d "[:space:]" | wc -m)

        i=0
        num_tabs=$((num_tabs - 2))

        while [ $i -lt "$num_tabs" ]; do
            printf "%s" "    "
            i=$((i + 1))
        done

        printf "%s [%s](#%s)\n" "-" "$text" "$link"
    done < "$1"
}

show_help() {
    echo "smalltoc - Lightweight Table-of-Content genrator
        Usage:
            smalltoc [Options]

            OPTIONS

            install/add - add script to \$PATH

            uninstall/remove - remove script from \$PATH

            -h/--help - show help and exit"
    exit
}

[ $# -eq 0 ] && printf "No arguments given\n"

case $1 in
    '' | '-h' | '--help')
        show_help
        ;;
    'install' | 'add')
        (set -x; sudo cp "$0" $INSTALL_PATH)
        ;;
    'uninstall' | 'remove')
        (set -x; sudo rm -i $INSTALL_PATH)
        ;;
    *)
        for arg in "$@"; do generate_toc "$arg"; done
        ;;
esac