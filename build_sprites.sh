#!/bin/bash

# Define where the icons are and where the output should go
INPUT="./svgs_iconset/"
OUTPUT="./sprites/osm-liberty"

echo "Building sprites from $INPUT..."

# Build Standard (1x)
spritezero "$OUTPUT" "$INPUT"

# Build Retina (2x)
spritezero --retina "$OUTPUT@2x" "$INPUT"

echo "Done!"