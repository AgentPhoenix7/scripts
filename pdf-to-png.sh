#!/usr/bin/env bash

set -e

INPUT="$1"
OUTPUT_DIR="${2:-png_pages}"

if [ -z "$INPUT" ]; then
    echo "Usage: $0 input.pdf [output_folder]"
    exit 1
fi

# Extract the base name of the PDF without path and extension
BASENAME="$(basename "$INPUT")"
PDF_NAME="${BASENAME%.*}"

mkdir -p "$OUTPUT_DIR"

gs \
  -dSAFER \
  -dBATCH \
  -dNOPAUSE \
  -sDEVICE=png16m \
  -r600 \
  -sOutputFile="${OUTPUT_DIR}/${PDF_NAME}-%03d.png" \
  "$INPUT"

echo ""
echo "PNG pages saved to: $OUTPUT_DIR"
