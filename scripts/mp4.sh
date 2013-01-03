#!/bin/sh
# MP4 mux

quote ()
{
  [[ ${!1} =~ \  ]] && read -r $1 <<< \"${!1}\"
}

warn ()
{
  printf "\e[36m%s\e[m\n" "$*"
}

log ()
{
  local pp
  for oo
  do
    quote oo
    pp+=("$oo")
  done
  warn "${pp[@]}"
  eval "${pp[@]}"
}

unquote ()
{
  read -r $1 <<< "${!1//\"}"
}

# stdin
while read -r -p 'Drag file here, or use a pipe.'$'\n' mm
do
  unquote mm
  nn="${mm%.*}.mp4"
  log ffmpeg -i "$mm" -c copy -nostdin -v warning "$nn"
done
