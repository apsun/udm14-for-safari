#!/bin/bash

if [ ! -f "$1" ]; then
    echo "usage: $0 icon.svg"
    exit 1
fi

svg_path="$1"

genicon() {
    dim="$1"
    dim1x=$(printf "%.0f" "$1")
    dim2x=$(printf "%.0f" "$(bc -l <<< "$1*2")")
    dim3x=$(printf "%.0f" "$(bc -l <<< "$1*3")")
    inkscape -o "AppIcon-$dim.png" "$svg_path" -w "$dim1x" -h "$dim1x"
    inkscape -o "AppIcon-$dim@2x.png" "$svg_path" -w "$dim2x" -h "$dim2x"
    # inkscape -o "AppIcon-$dim@3x.png" "$svg_path" -w "$dim3x" -h "$dim3x"
}

genicon 16
genicon 32
genicon 128
genicon 256
genicon 512
genicon 1024
