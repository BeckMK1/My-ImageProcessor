compress_single() {
    if [ -z "$1" ]; then
        echo "Usage: compress_single <file> [format]"
        return 1
    fi

    file="$1"
    format="${2:-jpg}"

    basename="${file%.*}"
    output="${basename}-compressed.${format}"

    magick "$file" \
        -resize '2020x2020>' \
        -quality 70 \
        "$output"
}

compress_multi() {
    dir="${1:-.}"
    format="${2:-jpg}"

    if [ ! -d "$dir" ]; then
        echo "Directory not found: $dir"
        return 1
    fi

    mkdir -p compressed

    for file in "$dir"/*; do
        [ -f "$file" ] || continue

        case "${file:l}" in
            (*.jpg|*.jpeg|*.png|*.webp)
                basename="${file%.*}"
                basename="${basename##*/}"
                output="compressed/${basename}-compressed.${format}"

                magick "$file" \
                    -resize '2020x2020>' \
                    -quality 70 \
                    "$output"
                ;;
        esac
    done
}