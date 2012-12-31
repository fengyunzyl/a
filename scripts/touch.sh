#!/bin/bash
# Touch

quote ()
{
  [[ ${!1} =~ [\ \&] ]] && read $1 <<< \"${!1}\"
}

warn ()
{
  echo -e "\e[1;35m$@\e[m"
}

log ()
{
  local gh
  for gg
  do
    quote gg
    gh+=("$gg")
  done
  warn "${gh[@]}"
  eval "${gh[@]}"
}

compgen -d | while read aa
do
  read bb < <(ls "$aa")
  log touch "$aa/$bb"
done
