#!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0 -d <directory> -f <clang-format-file> [-r]"
    exit 1
}

# Check if the correct number of arguments is passed
if [ $# -lt 1 ]; then
    usage
fi

# Initialize variables
RECURSIVE=false
DIRECTORY=""
CLANG_FORMAT_FILE=""

# Parse arguments
while getopts "h:d:f:r" opt; do
    case $opt in
        h)
            usage
            exit 0
            ;;
        d)
            DIRECTORY=$OPTARG
            ;;
        f)
            CLANG_FORMAT_FILE=$OPTARG
            ;;
        r)
            RECURSIVE=true
            ;;
		\?) # Case for invalid arg
            usage
            exit 1
            ;;
    esac
done

# Check if directory is provided
if [ -z "$DIRECTORY" ]; then
    usage
fi

# Check if the directory exists
if [ ! -d "$DIRECTORY" ]; then
    echo "Directory $DIRECTORY does not exist!"
    exit 1
fi

# Check if the clang-format file exists
if  [ -z "$CLANG_FORMAT_FILE" ]; then
	echo "Defaulting to root .clang-format file."
	CLANG_FORMAT_PATH="$HOME/.clang-format"

	if [ ! -f "$HOME/.clang-format" ]; then
		echo "Clang format file $CLANG_FORMAT_FILE does not exist!"
		exit 1
	fi
else
	if [ ! -f "$CLANG_FORMAT_FILE" ]; then
		echo "Clang format file $CLANG_FORMAT_FILE does not exist!"
		exit 1
	fi
fi

# Function to format files in the directory
format_files() {
    local DIR=$1
    echo "Formatting files in $DIR"

    # Find and format files
    find "$DIR" -type f \( -name "*.cpp" -o -name "*.hpp" -o -name "*.c" -o -name "*.h" -o -name "*.java" \) -exec clang-format -style=file -i --fallback-style=none {} +
}

# Perform formatting based on recursive option
if $RECURSIVE; then
    format_files "$DIRECTORY"
else
    find "$DIRECTORY" -maxdepth 1 -type f \( -name "*.cpp" -o -name "*.hpp" -o -name "*.c" -o -name "*.h"  -o -name "*.java" \) -exec clang-format -style=file -i --fallback-style=none {} +
fi

echo "Formatting complete."
