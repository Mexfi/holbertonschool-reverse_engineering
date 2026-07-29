#!/bin/bash

# 1. Yoxlamalar
if [ $# -ne 1 ] || [ ! -f "$1" ]; then
    echo "Error: File does not exist or invalid argument" >&2
    exit 1
fi

file_name="$1"

# 2. ELF yoxlanışı
readelf -h "$file_name" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: '$file_name' is not a valid ELF file" >&2
    exit 1
fi

# 3. readelf çıxışını yığırıq
elf_header=$(readelf -h "$file_name")

# 4. Dəyişənləri götürürük və sonundakı/əvvəlindəki artıq boşluqları silirik
magic_number=$(echo "$elf_header" | grep "Magic:" | sed -E 's/^[[:space:]]*Magic:[[:space:]]*//' | xargs)
class=$(echo "$elf_header" | grep "Class:" | awk '{print $2}' | xargs)
byte_order=$(echo "$elf_header" | grep "Data:" | awk -F',' '{print $2}' | xargs)
entry_point_address=$(echo "$elf_header" | grep "Entry point address:" | awk '{print $4}' | xargs)

# 5. messages.sh qoşulur
if [ -f "./messages.sh" ]; then
    source ./messages.sh
    display_elf_header_info
fi
