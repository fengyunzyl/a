#!/bin/sh
# Print different text colors

# 30 is black so you wont see it
printf '\e[31m%s\e[m\n' '31 Hello world'
printf '\e[32m%s\e[m\n' '32 Hello world'
printf '\e[33m%s\e[m\n' '33 Hello world'
printf '\e[34m%s\e[m\n' '34 Hello world'
printf '\e[35m%s\e[m\n' '35 Hello world'
printf '\e[36m%s\e[m\n' '36 Hello world'
printf '\e[37m%s\e[m\n' '37 Hello world'

printf '\e[1;30m%s\e[m\n' '1;30 Hello world'
printf '\e[1;31m%s\e[m\n' '1;31 Hello world'
printf '\e[1;32m%s\e[m\n' '1;32 Hello world'
printf '\e[1;33m%s\e[m\n' '1;33 Hello world'
printf '\e[1;34m%s\e[m\n' '1;34 Hello world'
printf '\e[1;35m%s\e[m\n' '1;35 Hello world'
printf '\e[1;36m%s\e[m\n' '1;36 Hello world'
printf '\e[1;37m%s\e[m\n' '1;37 Hello world'
