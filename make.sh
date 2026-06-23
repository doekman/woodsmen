#!/usr/bin/env bash
# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\n\t'

# Resize photo's

if [[ $# -lt 1 ]]; then
	echo "Usage: $0 path-to-original-jpg-files"
	exit 1
fi

SIZES=(2000 1536 1024 768 300)
PHOTOS="$1"
DEST="./docs/2026/index/photos"

rm -f $DEST/*
for PHOTO in "$PHOTOS"/*.jpg; do
	echo -n "- $PHOTO"
	PHOTO_BASE_NAME="$(basename "$PHOTO" | sed 's/.jpg//')"
	for SIZE in "${SIZES[@]}"; do
		echo -n "--$SIZE"
		sips --resampleWidth "$SIZE" "$PHOTO" --out "${DEST}/${PHOTO_BASE_NAME}--${SIZE}.jpg"
	done
	echo "."
done
