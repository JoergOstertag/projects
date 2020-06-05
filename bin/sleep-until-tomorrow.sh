#!/bin/bash

# untilTime="${1}"

sleepTime=$(($(date -f - +%s- <<< $'tomorrow 04:00\nnow')0));

echo "Sleeping $sleepTime sec = " $(( $sleepTime / 3600 )) "h ..."
sleep $sleepTime

