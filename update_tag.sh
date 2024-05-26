#!/bin/bash

# Check if a tag value was provided as an argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <new-tag>"
    exit 1
fi

# The new tag value
NEW_TAG=$1

# Path to the values.yaml file
FILE="Helm/values.yaml"

# Check if the file exists
if [ ! -f "$FILE" ]; then
    echo "Error: File does not exist."
    exit 1
fi

# Update the tag in the file
sed -E -i "s/^ *tag:.*$/  tag: $NEW_TAG/" $FILE


echo "Tag updated to '$NEW_TAG' in $FILE."
