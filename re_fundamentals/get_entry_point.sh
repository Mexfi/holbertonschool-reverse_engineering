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

# 3. readelf çıxışını bir dəfə dəyişənə yığırıq (prosesi sürətləndirmək üçün)
elf_header=$(readelf -h "$file_name")

# 4. Tələb olunan məlumatları parse edirik
# Magic Number (adətən 16 baytlıq hex ardıcıllığı)
magic_number=$(echo "$elf_header" | grep "Magic:" | sed -E 's/^[[:space:]]*Magic:[[:space:]]*//')

# Class (ELF32 və ya ELF64)
class=$(echo "$elf_header" | grep "Class:" | awk '{print $2}')

# Byte Order (Data sətrindən endianness hissəsini götürürük)
byte_order=$(echo "$elf_header" | grep "Data:" | sed -E 's/^[[:space:]]*Data:[[:space:]]*//')

# Entry Point Address
entry_point_address=$(echo "$elf_header" | grep "Entry point address:" | awk '{print $4}')

# 5. messages.sh faylını qoşuruq və funksiyanı çağırırıq
if [ -f "./messages.sh" ]; then
    source ./messages.sh
    display_elf_header_info
else
    # Əgər messages.sh cari qovluqda tapılmazsa fallback kimi formatlayırıq
    echo "Header Information for '$file_name':"
    echo "--------------------------------"
    echo "Magic Number: $magic_number"
    echo "Class: $class"
    echo "Byte Order: $byte_order"
    echo "Entry Point Address: $entry_point_address"
fi
