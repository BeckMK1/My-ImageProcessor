function compress_single
    if not -q argv[1]
        echo "Usage: compress_single <file> [format]"
        return 1
    end

    set file $argv[1]

    set format jpg

    if set -q argv[2]
        set format $argv[2]
    end 

    set basename (path change-extension "" $file)
    set output "$basename-compressed.$format"


    magick "$file" \
    -resize 2020x2020> \
    -quality 70 \
    "$output"
end