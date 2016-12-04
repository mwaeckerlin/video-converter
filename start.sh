#!/bin/bash -e

convert() {
    f="$1"
    for format in "${FORMATS}"; do
        flags=FLAGS_$format
        t="${f/$SRC/$DST}"
        t="${t%.*}.${format}"
        if test -e "$t"; then
	    rm "$t"; # remove existing file
        fi
        test -d "${t%/*}" || mkdir -p "${t%/*}"
        echo "++++ $f → $t"
        if ( ! avconv -i "$f" ${!flags} -filter:v yadif "$t" \
            || ! test -s "${t}") && test -e "$t"; then
	    rm "$t"; # remove file if conversion failed
        fi
    done
}

echo "**** converting existing files"
for f in $(find $SRC -type f); do
    t="${f/$SRC/$DST}"
    t="${t%.*}.${format}"
    if test -s "${t}"; then
	continue; # ignore if file exists and is not empty
    fi
    convert "$f"
done

echo "==== initialized, starting service"
inotifywait -r --format '%w' -e modify,attrib,move,create,delete ${SRC} |
    while read p; do
        convert "$p"
    done
