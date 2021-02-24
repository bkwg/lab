#!/bin/bash

while IFS= read -r line
do
    printf "%-45s\t%s\n" $line $(./crc32 "$line")
done < "$1"
