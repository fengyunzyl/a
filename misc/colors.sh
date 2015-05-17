#!/bin/sh
al=(
         # foreground   background
  '0;30' # reg black    reg black
  '0;31' # reg red      reg black
  '0;32' # reg green    reg black
  '0;33' # reg yellow   reg black
  '0;34' # reg blue     reg black
  '0;35' # reg purple   reg black
  '0;36' # reg cyan     reg black
  '0;37' # reg white    reg black
  '1;30' # bold black   reg black
  '1;31' # bold red     reg black
  '1;32' # bold green   reg black
  '1;33' # bold yellow  reg black
  '1;34' # bold blue    reg black
  '1;35' # bold purple  reg black
  '1;36' # bold cyan    reg black
  '1;37' # bold white   reg black
  '5;30' # reg black    bold black
  '5;31' # reg red      bold black
  '5;32' # reg green    bold black
  '5;33' # reg yellow   bold black
  '5;34' # reg blue     bold black
  '5;35' # reg purple   bold black
  '5;36' # reg cyan     bold black
  '5;37' # reg white    bold black

  '7;31' # reg black    reg red
  '4;41' # reg cyan     reg red
  '0;41' # reg white    reg red
  '1;41' # bold white   reg red
  '5;41' # reg white    bold red

  '7;32' # reg black    reg green
  '4;42' # reg cyan     reg green
  '0;42' # reg white    reg green
  '1;42' # bold white   reg green
  '5;42' # reg white    bold green

  '7;33' # reg black    reg yellow
  '4;43' # reg cyan     reg yellow
  '0;43' # reg white    reg yellow
  '1;43' # bold white   reg yellow
  '5;43' # reg white    bold yellow

  '7;34' # reg black    reg blue
  '4;44' # reg cyan     reg blue
  '0;44' # reg white    reg blue
  '1;44' # bold white   reg blue
  '5;44' # reg white    bold blue

  '7;35' # reg black    reg purple
  '4;45' # reg cyan     reg purple
  '0;45' # reg white    reg purple
  '1;45' # bold white   reg purple
  '5;45' # reg white    bold purple

  '7;36' # reg black    reg cyan
  '4;46' # reg cyan     reg cyan
  '0;46' # reg white    reg cyan
  '1;46' # bold white   reg cyan
  '5;46' # reg white    bold cyan

  '7;40' # reg black    reg white
  '7;41' # reg red      reg white
  '7;42' # reg green    reg white
  '7;43' # reg yellow   reg white
  '7;44' # reg blue     reg white
  '7;45' # reg purple   reg white
  '7;46' # reg cyan     reg white
  '7;47' # reg white    reg white
  '1;47' # bold white   reg white
  '5;47' # reg white    bold white
)

for bra in "${al[@]}"
do
  printf '%s fg [\e[%bm██\e[m] bg [\e[%bm  \e[m]\n' "$bra"{,,}
done
