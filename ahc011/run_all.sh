#!/usr/bin/bash

files="./input/*"
for filepath in $files; do
    time ./main < $filepath
done
