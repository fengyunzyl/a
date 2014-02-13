foo=(%H%M%S 
     %a %b %c %d %e    %g %h    %j %k %l %m    %p %r %s    %u    %w %x %y %z
     %A %B %C %D    %F %G %H %I          %M %N %P %R %S %T %U %V %W %X %Y %Z
     %:z %::z %:::z)

for blah in ${foo[*]}
do
  printf '%s\t' $blah
  date +$blah
done
