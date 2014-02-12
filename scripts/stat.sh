usage () {
  echo usage: ${0##*/} ITEM
  exit
}

(( $# )) || usage

for foo in a b c d f g h i l m n o s t u w x y z A B C D F G N S T U W X Y Z
do
  printf '%s\t' $foo
  stat -c %$foo "$1"
done
