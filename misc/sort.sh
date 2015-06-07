#!/bin/sh
sed 's/ //' /dev/clipboard |
sort --unique --human-numeric-sort
