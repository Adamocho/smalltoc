#!/bin/sh

INSTALL_PATH="/usr/bin/smalltoc"

generate_toc() {

    [ -e $1 ] && echo "Generating TOC for $1:\n" && printf "## Table of content\n" 

    before=2

    while IFS= read -r line
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
    done < $1
}

show_help() {
    echo "smalltoc - Lightweight Table of content genrator
        Usage:
            smalltoc [Options]

            OPTIONS

            install/add - add script to \$PATH

            uninstall/remove - remove script from \$PATH

            -h/--help - show help and exit"
    exit
}

[ $# -eq 0 ] && echo "No arguments given\n"

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
        for arg in "$@"; do generate_toc $arg; done
        ;;
esac