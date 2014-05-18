# Print different text colors

# 30 is black so you wont see it
foo=(          31     32     33     34     35     36     37
     '1;30' '1;31' '1;32' '1;33' '1;34' '1;35' '1;36' '1;37')

for bar in "${foo[@]}"
do
  printf "\e[${bar}m%s\e[m\n" "\e[${bar}m%s\e[m"
done
