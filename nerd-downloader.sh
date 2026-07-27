#!/bin/bash

# Directory to store the downloaded release
DOWNLOAD_DIR="$HOME/.local/share/fonts/nerdfonts"
LATEST_RELEASE_FILE="$DOWNLOAD_DIR/latest_release.txt"

# Create the download directory if it doesn't exist
mkdir -p "$DOWNLOAD_DIR"

# Create the latest release file if it doesn't exist
if [ ! -f "$LATEST_RELEASE_FILE" ]; then
  touch "$LATEST_RELEASE_FILE"
fi

# GitHub repo details
REPO="ryanoasis/nerd-fonts"
API_URL="https://api.github.com/repos/$REPO/releases/latest"

# Get the latest release tag from GitHub API
LATEST_RELEASE=$(curl -s "$API_URL" | grep -Po '"tag_name": "\K.*?(?=")')

# Check if the latest release is already downloaded
if [ -f "$LATEST_RELEASE_FILE" ]; then
  CURRENT_RELEASE=$(cat "$LATEST_RELEASE_FILE")
else
  CURRENT_RELEASE=""
fi

# Download the latest release if it's new
if [ "$LATEST_RELEASE" != "$CURRENT_RELEASE" ]; then
  echo "New release found: $LATEST_RELEASE"
  
  # Define the fonts to download (add more if necessary)
  FONT_FILES=(
    "BigBlueTerminal.zip"
    "CascadiaCode.zip"
    "ComicShannsMono.zip"
    "DaddyTimeMono.zip"
    "FiraCode.zip"
    "Go-Mono.zip"
    "Gohu.zip"
    "Hack.zip"
    "HeavyData.zip"
    "Hermit.zip"
    "Iosevka.zip"
    "JetBrainsMono.zip"
    "Meslo.zip"
    "OpenDyslexic.zip"
    "ProFont.zip"
    "ProggyClean.zip"
    "ShareTechMono.zip"
    "NerdFontsSymbolsOnly.zip"
    "Terminus.zip"
    "Tinos.zip"
    # Add more font zip files as needed
  )
  
  # Download each font zip file
  for FILE in "${FONT_FILES[@]}"; do
    URL="https://github.com/$REPO/releases/download/$LATEST_RELEASE/$FILE"
    ZIP_PATH="$DOWNLOAD_DIR/$FILE"
    
    # Download the font zip file
    echo "Downloading $FILE..."
    if curl -L -o "$ZIP_PATH" "$URL"; then
      # Unzip the font into the nerdfonts directory
      echo "Extracting $FILE..."
      unzip -o "$ZIP_PATH" -d "$DOWNLOAD_DIR"
      
      # Remove the zip file after extraction
      rm "$ZIP_PATH"
    else
      echo "Error downloading $FILE. Skipping..."
    fi
  done

  # Update the latest release file
  echo "$LATEST_RELEASE" > "$LATEST_RELEASE_FILE"
  echo "Downloaded and installed fonts from $LATEST_RELEASE to $DOWNLOAD_DIR"
  
  # Update the font cache
  echo "Updating font cache..."
  fc-cache -fv
else
  echo "No new release found."
fi 
