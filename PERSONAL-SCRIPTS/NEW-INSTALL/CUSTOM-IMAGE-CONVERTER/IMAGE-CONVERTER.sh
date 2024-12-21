#!/bin/bash

### META_DATA ###
# Author: Tolga Erok
# Date: 12/1/2024
# VERSION: 3
# Description: Image converter using ImageMagick

### Constants and Variables ###
OUTPUT_FOLDER="CONVERTED"
SUPPORTED_FORMATS=("png" "jpg" "jpeg" "gif" "bmp" "tiff" "avif" "heic")

### Functions ###

check_imagick() {
    if ! command -v convert &>/dev/null; then
        read -p "ImageMagick is not installed. Install it? (y/n): " -n 1 -r
        echo
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            # Detect package manager and install ImageMagick accordingly
            if command -v dnf &>/dev/null; then
                sudo dnf install -y ImageMagick
            elif command -v eopkg &>/dev/null; then
                sudo eopkg install -y imagemagick
            else
                echo "Unsupported package manager. Please install ImageMagick manually."
                echo "  - On Fedora: sudo dnf install ImageMagick"
                echo "  - On Solus: sudo eopkg install imagemagick"
                exit 1
            fi
        else
            echo "Please install ImageMagick and run the script again."
            exit 1
        fi
    fi
}

convert_images() {
    local output_format="$1"
    local image_files=()

    # Validate output format
    if [[ ! " ${SUPPORTED_FORMATS[@]} " =~ " $output_format " ]]; then
        echo "Error: Unsupported format '$output_format'. Supported formats: ${SUPPORTED_FORMATS[*]}"
        return 1
    fi

    # Create output folder if not exists
    mkdir -p "$OUTPUT_FOLDER"

    # Get image files in the current directory (PWD)
    for file in *.{${SUPPORTED_FORMATS[@]}}; do
        image_files+=("$file")
    done

    # Check if there are any images to convert
    if [ ${#image_files[@]} -eq 0 ]; then
        echo "No images found for conversion."
        return 1
    fi

    # Count and show their extensions
    local unique_ext=($(printf "%s\n" "${image_files[@]##*.}" | sort -u))
    echo "Found ${#image_files[@]} image(s) with extension(s): ${unique_ext[*]}"

    # Convert images in parallel using xargs for potential speedup
    printf "%s\n" "${image_files[@]}" | xargs -P "$(nproc)" -I {} bash -c \
        "convert {} \"$OUTPUT_FOLDER/{}-converted.$output_format\" 2>/dev/null && echo \"Converted: {} to $output_format\""
}

### Main Script ###

check_imagick

# Prompt user for chosen output format with select menu
while true; do
    echo "Select the desired output format:"
    select output_format in "${SUPPORTED_FORMATS[@]}"; do
        [ -n "$output_format" ] && break
        echo "Invalid selection. Please try again."
    done
    echo "Selected output format: $output_format"
    break
done

# Start to convert images
if ! convert_images "$output_format"; then
    echo "Conversion failed. Please check the logs for more information."
else
    echo "Conversion complete."
fi
