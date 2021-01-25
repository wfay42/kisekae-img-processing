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

if [[ "$1" = '-f' ]] ; then
    copy_into_game_dir=true
fi

created_files_file=created_files.txt
rm -f $created_files_file
# side-effect: adds output file to created_files list
function crop_file() {
    local file="$1"
    local offsets="$2"
    local output="$3"
    convert "$file" -crop 420x720"$offsets" "$output"
    echo "$output" >> $created_files_file
}

## assume quality level 5 PNG export so 2505 × 1500
# process files for actors1
for num in 1 2 ; do
    file=actors1_$num.png
    crop_file "$file" +135+220 "delegate_1_$num.png" &
    crop_file "$file" +580+220 "delegate_2_$num.png" &
    crop_file "$file" +1033+220 "delegate_3_$num.png" &
    crop_file "$file" +1476+260 "crew_1_$num.png" &
    crop_file "$file" +1900+235 "crew_2_$num.png" &
done

# process files for actors2
for num in 1 2 3 4 ; do
    file=actors2_$num.png
    crop_file "$file" +260+290 "doctor_$num.png" &
    crop_file "$file" +833+227 "captain_$num.png" &
    crop_file "$file" +1382+359 "holo_$num.png" &
done

# wait for background tasks to finish
wait

if [[ -n "$copy_into_game_dir" ]] ; then
    xargs -I{} cp {} ../img/pictures/ < "$created_files_file"
fi
