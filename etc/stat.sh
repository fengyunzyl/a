#!/bin/sh
if [ "$#" != 1 ]
then
  echo 'stat.sh [item]'
  exit
fi

for each in a b c d f g h i l m n o s t u w x y z A B D F G N S T U W X Y Z
do
  printf '%s\t' $each
  stat -c %$each "$1"
done
