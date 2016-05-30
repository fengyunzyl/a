#!/bin/dash
if [ "$#" = 0 ]
then
  cat <<+
printf.sh [-e] [input]
-e    treat input as expression instead of string
+
  exit
fi

if [ "$1" = -e ]
then
  al=$(printf '{br=%s}' "$2")
else
  al=$(printf '{br="%s"}' "$1")
fi

awk "$al"'{printf "%" $0 "\t" $0 "\n", br}' <<+
%a
%b
%d
%e
%.0f
%.7f
%g
%h
%i
%j
%k
%l
%m
%n
%o
%p
%q
%r
%s
%t
%u
%v
%w
%x
%y
%z
+
