#!/bin/bash

## Example script to crop multiple screenshots and combine them

# crop an individual file
function alterfile() {
    local file
    file="$1"
    echo "$file"
    outfile=$(echo "output-$file" | sed 's/ /-/g')

    # if fullscreen
    convert "$file" -crop 3840x2400+200-130 -crop 3840x2400-200+0 "$outfile"

    # if windowed
    #convert "$file" -crop 4064x2587+800-400 -crop 4064x2587-800+130 "$outfile"
}

# combine images into groups of 3 images
function combine() {
    local max i file
    max=3
    filenum=0
    i=0
    filelist=''
    for infile in output-*.png ; do
        filelist="$filelist $infile"
        i=$((i+1))
        if [[ "$i" -gt 2 ]] ; then
            i=0
            outfile="combined-output-$(printf '%03d' $filenum).png"
            echo "Creating file $outfile"
            convert -append $filelist "$outfile" &

            filenum=$((filenum+1))
            filelist=''
        fi
    done
    if [[ -n "$filelist" ]] ; then
        outfile="combined-output-$(printf '%03d' $filenum).png"
        echo "Creating file $outfile"
        convert -append $filelist "$outfile" &
    fi

    wait
}

for file in actors1.png; do
    # assume quality level 5 PNG export so 2505 × 1500
    convert "$file" -crop 420x720+135+220 "delegate_1_1.png" &
    convert "$file" -crop 420x720+580+220 "delegate_2_1.png" &
    convert "$file" -crop 420x720+1033+220 "delegate_3_1.png" &
    convert "$file" -crop 420x720+1476+260 "crew_1_1.png" &
    convert "$file" -crop 420x720+1900+235 "crew_1_2.png" &

    # wait for background tasks to finish
    wait
done
