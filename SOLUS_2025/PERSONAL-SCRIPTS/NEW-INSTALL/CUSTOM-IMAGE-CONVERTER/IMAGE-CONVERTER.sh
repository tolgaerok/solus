#!/bin/bash

### META_DATA ###
# Author: Tolga Erok
# Date: 12/21/2024
# VERSION: 8
# Description: Image converter using ImageMagick with debugging

### Constants and Variables ###
OUTPUT_FOLDER="CONVERTED"
SUPPORTED_FORMATS=("png" "jpg" "jpeg" "gif" "bmp" "tiff" "avif" "heic")

### Functions ###

check_imagick() {
    if ! command -v magick &>/dev/null; then
        read -p "ImageMagick is not installed. Install it? (y/n): " -n 1 -r
        echo
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            if command -v dnf &>/dev/null; then
                sudo dnf install -y ImageMagick
            elif command -v eopkg &>/dev/null; then
                sudo eopkg install -y imagemagick
            else
                echo "Unsupported package manager. Please install ImageMagick manually."
                exit 1
            fi
        else
            echo "Please install ImageMagick and run the script again."
            exit 1
        fi
    fi
}

prepare_output_folder() {
    mkdir -p "$OUTPUT_FOLDER"
    chmod u+w "$OUTPUT_FOLDER" || {
        echo "Failed to set permissions on the output folder. Exiting."
        exit 1
    }
}

convert_images() {
    local output_format="$1"
    local image_files=()

    # Validate output format
    if [[ ! " ${SUPPORTED_FORMATS[@]} " =~ " $output_format " ]]; then
        echo "Error: Unsupported format '$output_format'. Supported formats: ${SUPPORTED_FORMATS[*]}"
        return 1
    fi

    # Get image files in the current directory
    shopt -s nullglob
    for file in *.heic *.jpg *.jpeg *.png *.gif *.bmp *.tiff *.avif; do
        [[ -e "$file" ]] && image_files+=("$file")
    done
    shopt -u nullglob

    # Debug: Show found files
    echo -e "\033[1;34mFound ${#image_files[@]} image(s):\033[0m"
    if [ ${#image_files[@]} -eq 0 ]; then
        echo "No images found for conversion."
        return 1
    fi
    printf "%s\n" "${image_files[@]}"

    # Convert images sequentially
    echo -e "\033[1;34mConverting images one by one...\033[0m"
    for file in "${image_files[@]}"; do
        echo -e "\033[1;34mConverting: $file\033[0m"
        output_path="$OUTPUT_FOLDER/$(basename "$file" | sed 's/\.[^.]*$//')-converted.$output_format"
        echo "Output path: $output_path"

        # Debug ImageMagick conversion
        if magick "$file" "$output_path"; then
            echo -e "\033[1;32m✔ Successfully converted: $file\033[0m"
        else
            echo -e "\033[1;31m✘ Failed to convert: $file\033[0m"
        fi
    done

    echo -e "\033[1;34mAll conversions are complete.\033[0m"
}

### Main Script ###

check_imagick
prepare_output_folder

# Prompt user for chosen output format
while true; do
    echo -e "\033[1;34mSelect the desired output format:\033[0m"
    select output_format in "${SUPPORTED_FORMATS[@]}"; do
        [ -n "$output_format" ] && break
        echo "Invalid selection. Please try again."
    done
    echo -e "\033[1;34mSelected output format: $output_format\033[0m"
    break
done

# Start process
if ! convert_images "$output_format"; then
    echo "Conversion failed. Please check the logs for more information."
else
    echo "Conversion complete."
    echo "Converted files are located in the '$OUTPUT_FOLDER' directory."
fi
