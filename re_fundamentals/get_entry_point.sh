#!/bin/bash

# 1. Arqumentin verilib-verilmədiyini və faylın mövcudluğunu yoxlayırıq
if [ $# -ne 1 ] || [ ! -f "$1" ]; then
    echo "Error: File does not exist or invalid argument" >&2
    exit 1
fi

file_name="$1"

# 2. Faylın ELF olub-olmadığını yoxlayırıq
readelf -h "$file_name" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: '$file_name' is not a valid ELF file" >&2
    exit 1
fi

# 3. readelf çıxışını bir dəfə dəyişənə yığırıq
elf_header=$(readelf -h "$file_name")

# 4. Tələb olunan məlumatları parse edirik
# Magic Number (ekstra boşluqları təmizləyirik)
magic_number=$(echo "$elf_header" | grep "Magic:" | sed -E 's/^[[:space:]]*Magic:[[:space:]]*//')

# Class (ELF32 və ya ELF64)
class=$(echo "$elf_header" | grep "Class:" | awk '{print $2}')

# Byte Order: yalnız 'little endian' və ya 'big endian' hissəsini götürürük
byte_order=$(echo "$elf_header" | grep "Data:" | awk -F',' '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

# Entry Point Address
entry_point_address=$(echo "$elf_header" | grep "Entry point address:" | awk '{print $4}')

# 5. messages.sh faylını qoşub funksiyanı çağırırıq
if [ -f "./messages.sh" ]; then
    source ./messages.sh
    display_elf_header_info
fi
