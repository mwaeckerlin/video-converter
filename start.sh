#!/bin/bash -e

target() {
    f="$1"
    format="$2"
    t="${f/$SRC/$DST/$format}"
    t="${t%.*}.${format}"
    echo -n "$t"
}

convert() {
    f="$1"
    format="$2"
    flags=FLAGS_$format
    t=$(target "$f" "$format")
    if test -e "$t"; then
	rm "$t"; # remove existing file
    fi
    test -d "${t%/*}" || mkdir -p "${t%/*}"
    echo "++++ $f → $t"
    if ( ! avconv -i "$f" ${!flags} -filter:v yadif "$t" 2> /dev/null > /dev/null \
               || ! test -s "${t}") && test -e "$t"; then
        file "$f"
        echo "**** ERROR: avconv -i '$f' ${!flags} -filter:v yadif '$t'"
	rm "$t"; # remove file if conversion failed
    fi
}

echo "==== converting existing files"
for f in $(find $SRC -name '.*' -prune -o -type f -print); do
    for format in ${FORMATS}; do
        t=$(target "$f" "$format")
        if test -s "${t}"; then
	    continue; # ignore if file exists and is not empty
        fi
        convert "$f" "$format"
    done
done

echo "==== initialized, starting service"
inotifywait -r --format '%w' -e modify,attrib,move,create,delete ${SRC} |
    while read p; do
        if test -f "-p"; then
            for format in ${FORMATS}; do
                convert "$p" "$format"
            done
        else
            for format in ${FORMATS}; do
                t=$(target "$f" "$format")
                if test -f "$t"; then
                    echo "---- $t"
                    rm "$t"
                fi
            done
        fi
    done
