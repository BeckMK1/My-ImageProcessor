#!/usr/bin/env fish

function compress_single
    if not set -q argv[1]
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
    -resize '2020x2020>' \
    -quality 70 \
    "$output"
end

function compress_multi
    if not set -q argv[1]
        echo "Usage: compress_multi <dir> [format]"
        return 1
    end

    set dir $argv[1]
    set format jpg

    if set -q argv[2]
        set format $argv[2]
    end

    mkdir -p compressed

    for file in $dir/*
        if not test -f "$file"
            continue
        end

        switch (string lower (path extension $file))
            case .jpg .jpeg .png .webp
                set basename (path basename (path change-extension "" $file))
                set output "compressed/$basename-compressed.$format"

                magick "$file" \
                    -resize '2020x2020>' \
                    -quality 70 \
                    "$output"
        end
    end
end

# -------------------------
# CLI router
# -------------------------

set cmd $argv[1]
set argv $argv[2..-1]

switch $cmd
    case compress
        compress_single $argv
    case compress_multi
        compress_multi $argv
    case '*'
        echo "Usage:"
        echo "  imgp compress <file> [format]"
        echo "  imgp multi <dir> [format]"
        return 1
end