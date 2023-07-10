#!/bin/sh

INSTALL_PATH="/usr/bin/smalltoc"
OUTPUT_DIR="$HOME/.cache/smalltoc"
OUTPUT_FILE="$OUTPUT_DIR/README.md"

# Stdout is captured by 'parse_args' function
generate_toc() {
    # Search for lines starting with two (or more) '#' hashtags
    lines=$( grep -E "#{2,}[[:space:]][[:alnum:]]" "$1" )

    # Create temp file for this (in order for the while loop below to work).
    # It is faster than going line-by-line for the whole file anyway.
    temp_file=$( mktemp tmp.XXXX -p "$TMP_DIR" )

    printf "%s" "$lines" > "$temp_file"

    # Saddly this is the correct syntax for this mess
    # Just remember - one can't put a '$' sign before either 'lines' nor 'line'.
    while lines="" read -r line
    do
        # Skip, if it contains 'Table of Content' (case insensitive)
        [ "$( echo "$line" | grep -Ei '##[[:space:]]*table[[:space:]]*of[[:space:]]*content.*' )" ] && continue

        # Get text for link (basically copy the header without hashtags)
        text_part=$( echo "$line" | cut -d ' ' -f 1 --complement )
       
        # Get the link part, which looks like: (example-section)
        link_part=$( echo "$text_part" | xargs | tr ' ' '-' | tr '[:upper:]' '[:lower:]' )

        # Calculate the number of tabulators...
        number_of_tabs=$( echo "$line" | cut -d ' ' -f 1 | tr -d "[:space:]" | wc -m )
        number_of_tabs=$(( $number_of_tabs - 2 ))
        tabs_iterator=0

        # ...and shift the line that many times
        while [ "$tabs_iterator" -lt "$number_of_tabs" ]; do
            # Add tabulator (\t didn't work for some reason)
            printf "%s" "    "
            tabs_iterator=$(( $tabs_iterator + 1 ))
        done

        # Create link to the section
        printf "%s [%s](#%s)\n" "-" "$text_part" "$link_part"

    # Use the tmp file here
    done < "$temp_file"
}

parse_args() {
    # Generate TOC for each file given.
    for file in "$@"
        do
        [ -e "$1" ] && printf "Generating TOC for %s:\n" "$1"

        # Create the directory if needed (no error otherwise).
        mkdir -p "$OUTPUT_DIR"

        # Generate the ToC for the current file.
        table_of_content=$( printf "## Table of Content\n%s" "$(generate_toc "$file")" )

        # Locate the first double-hashtag occurence
        hashtag_twice=$( grep -Enim 2 '#{2,}' "$file" )

        # And the number of them
        number_of_hashtag_twice=$( grep -Enim 2 -c '#{2,}' "$file" )

        # If there are none found, just paste the toc to output
        if [ "$number_of_hashtag_twice" -eq 0 ]
        then
            cat "$file" > "$OUTPUT_FILE"
            printf "\n%s" "$table_of_content" >> "$OUTPUT_FILE"

            continue
        fi

        # Locate where to put TOC in
        top_part=$( echo "$hashtag_twice" | head -1 )
        bottom_part=$( echo "$hashtag_twice" | tail -1 )

        [ "$( echo "$top_part" | grep -Ei 'table[[:space:]]*of[[:space:]]*content.*' )" ] || bottom_part="$top_part"

        top_part=$( echo "$top_part" | cut -d : -f 1 )
        bottom_part=$( echo "$bottom_part" | cut -d : -f 1 )

        # Merge TOC into file
        # Start
        head -"$(( $top_part - 1 ))" "$file" > "$OUTPUT_FILE"
        # Middle - add TOC
        printf "\n%s\n\n" "$table_of_content" >> "$OUTPUT_FILE"
        # End
        tail -n +"$bottom_part" "$file" >> "$OUTPUT_FILE"

        # Debug for the end-user
        printf "The file is saved in %s\n" "$OUTPUT_FILE"
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
        (set -x; sudo cp "$0" "$INSTALL_PATH")
        ;;
    'uninstall')
        (set -x; sudo rm -i "$INSTALL_PATH")
        ;;
    *)
        parse_args "$@"
        ;;
esac
