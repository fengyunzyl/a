#!/bin/sh
# Print Cygwin mirrors
r=sources.redhat.com/cygwin/mirrors.lst

exec 3<>/dev/tcp/${r%%/*}/80
echo -e "GET /${r#*/}\nConnection:close\nHost:${r%%/*}" >&3

grep "United States" <&3 \
  | grep "ftp" \
  | cut -d\; -f1 \
  | while read r; do echo "${#r} $r"; done \
  | sort
