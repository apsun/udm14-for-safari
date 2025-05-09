#!/bin/bash

if [ ! -f "$1" ]; then
    echo "usage: $0 icon.svg"
    exit 1
fi

svg_path="$1"
inkscape="/Applications/Inkscape.app/Contents/MacOS/inkscape"

for size in 16 32 48 64 96 128 144 192 256 512 1024; do
    "$inkscape" -o "${svg_path%.svg}-${size}.png" "$svg_path" -w "${size}" -h "${size}"
done
