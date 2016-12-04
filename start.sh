#!/bin/bash -e

convert() {
    f="$1"
    for format in ${FORMATS}; do
        flags=FLAGS_$format
        t="${f/$SRC/$DST}"
        t="${t%.*}.${format}"
        if test -e "$t"; then
	    rm "$t"; # remove existing file
        fi
        test -d "${t%/*}" || mkdir -p "${t%/*}"
        file "$f"
        echo "++++ $f → $t"
        if ( ! avconv -i "$f" ${!flags} -filter:v yadif "$t" 2> /dev/null > /dev/null \
                   || ! test -s "${t}") && test -e "$t"; then
            echo "**** ERROR: avconv -i '$f' ${!flags} -filter:v yadif '$t'"
	    rm "$t"; # remove file if conversion failed
        fi
    done
}

echo "**** converting existing files"
for f in $(find $SRC -name '.*' -prune -o -type f -print); do
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
