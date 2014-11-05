if (( $# != 1 ))
then
  echo date.sh DATE
  exit
fi

sq=(%H%M%S '%b %-d %Y'
    %a %b %c %d %e    %g %h    %j %k %l %m    %p %r %s    %u    %w %x %y %z
    %A %B %C %D    %F %G %H %I          %M %N %P %R %S %T %U %V %W %X %Y %Z
    %:z %::z %:::z)

for each in "${sq[@]}"
do
  printf '%-11s' "$each"
  date -d "$1" +"$each"
done
