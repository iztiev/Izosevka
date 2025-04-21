#!/bin/bash

# Script to patch all fonts in a given directory using Nerd Fonts font-patcher

# --- Configuration ---
# Set the path to the Nerd Fonts font-patcher script if it's not in your PATH
# or if fontforge requires the full path.
# If fontforge finds 'font-patcher' automatically based on its installation or PATH,
# you can leave this as just 'font-patcher'.
FONT_PATCHER_SCRIPT="font-patcher"

# --- Script Logic ---

# Check if a directory path was provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <path_to_fonts_directory>"
  exit 1
fi

# Store the directory path from the first argument
FONTS_DIR="$1"

# Check if the provided path is actually a directory
if [ ! -d "$FONTS_DIR" ]; then
  echo "Error: '$FONTS_DIR' is not a valid directory."
  exit 1
fi

# Check if fontforge command exists
if ! command -v fontforge &> /dev/null; then
    echo "Error: 'fontforge' command not found. Please install fontforge."
    exit 1
fi

echo "Starting font patching process in directory: $FONTS_DIR"
echo "Using font-patcher script: $FONT_PATCHER_SCRIPT"
echo "--------------------------------------------------"

# Find font files (ttf, otf) in the specified directory (case-insensitive)
# and process each file.
# -iname '*.ttf' -o -iname '*.otf' : Find files ending with .ttf or .otf (case-insensitive)
# -print0 : Print filenames separated by null characters (handles spaces/special chars)
# xargs -0 -I {} : Read null-separated input and execute command for each item, replacing {} with the item
find "$FONTS_DIR" \( -iname '*.ttf' -o -iname '*.otf' \) -print0 | while IFS= read -r -d $'\0' font_file; do
  echo "Processing font: $font_file"

  # Run the fontforge patcher script on the font file
  # Add any specific options for font-patcher here if needed (e.g., --complete, --windows, etc.)
  fontforge -script "$FONT_PATCHER_SCRIPT" --complete "$font_file"

  # Check the exit status of the fontforge command
  if [ $? -eq 0 ]; then
    echo "Successfully patched: $font_file"
  else
    echo "Error patching: $font_file"
    # Decide if you want the script to stop on error or continue
    # exit 1 # Uncomment this line to stop the script on the first error
  fi
  echo "--------------------------------------------------"
done

echo "Font patching process completed."
exit 0
