#!/bin/sh
printf '%s %s %s' {,http://,https://}$(</dev/clipboard) | tee /dev/clipboard
printf '\ncopied to clipboard\n'
