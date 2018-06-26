#!/bin/bash
echo a
echo
echo b

for pc in $(seq 1 4); do
    echo -ne "$pc%\033[0K\r"
    sleep 1
done

echo