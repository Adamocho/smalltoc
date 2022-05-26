#!/bin/sh

INSTALL_PATH="/usr/bin/smalltoc"

generate_toc() {
    while IFS= read -r line
    do
        line=$(echo "$line" | grep -E "#{2,}[[:space:]][[:alnum:]]")

        [ -z "$line" ] && continue

        [ "$(echo "$line" | grep -Ei '##[[:space:]]*table[[:space:]]*of[[:space:]]*content.*')" ] && continue

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

parse_args() {
    for arg in "$@"
        do
        [ -e "$1" ] && printf "Generating TOC for %s:\n" "$1"

        OUTPUT_DIR="$HOME/.cache/smalltoc"
        OUTPUT_FILE="$OUTPUT_DIR/README.md"
        mkdir -p "$OUTPUT_DIR"

        printf "The file is saved in %s\n" "$OUTPUT_FILE"

        toc="$( printf "## Table of Content\n%s" "$(generate_toc "$arg")" )"
        htwos="$( grep -Enim 2 '#{2,}' "$arg" )"
        htwos_num="$( grep -Enim 2 -c '#{2,}' "$arg" )"

        if [ "$htwos_num" -eq 0 ]
        then
            cat "$arg" > "$OUTPUT_FILE"
            printf "\n%s" "$toc" >> "$OUTPUT_FILE"
            continue
        fi

        a=$(echo "$htwos" | head -1)
        b=$(echo "$htwos" | tail -1)

        [ "$(echo "$a" | grep -Ei 'table[[:space:]]*of[[:space:]]*content.*' )" ] || b="$a"

        a="$(echo "$a" | cut -d : -f 1 )"
        b="$(echo "$b" | cut -d : -f 1 )"

        head -"$(( a - 1 ))" "$arg" > "$OUTPUT_FILE"

        printf "\n%s\n\n" "$toc" >> "$OUTPUT_FILE"

        tail -n +"$b" "$arg" >> "$OUTPUT_FILE"

    done
}

show_help() {
    echo "smalltoc - Lightweight Table-of-Content genrator
        Usage:
            smalltoc [Options] [file1] [file2] [...]

            OPTIONS

            install - add script to \$PATH

            uninstall - remove script from \$PATH

            -h/--help - show help and exit"
    exit
}

[ $# -eq 0 ] && printf "No arguments given\n"

case $1 in
    '' | '-h' | '--help')
        show_help
        ;;
    'install')
        (set -x; sudo cp "$0" $INSTALL_PATH)
        ;;
    'uninstall')
        (set -x; sudo rm -i $INSTALL_PATH)
        ;;
    *)
        parse_args "$@"
        ;;
esac
