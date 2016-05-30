#!/bin/dash
if [ "$#" != 1 ]
then
  cat <<+
NAME
  date.sh

SYNOPSIS
  date.sh [date]

EXAMPLE
  date.sh 2015-5-15
+
  exit
fi

al=$1

while read br
do
  printf '%-11s' "$br"
  date -d "$al" +"$br"
done <<+
%a
%b
%c
%d
%e
%g
%h
%j
%k
%l
%m
%p
%r
%s
%u
%w
%x
%y
%z
%A
%B
%C
%D
%F
%G
%H
%I
%M
%N
%P
%R
%S
%T
%U
%V
%W
%X
%Y
%Z
%:z
%::z
%:::z
%Y%m%d
%H%M%S
%b %-d %Y
+
