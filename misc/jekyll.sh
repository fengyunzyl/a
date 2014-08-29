# Launch Jekyll
function browse {
  case $OSTYPE in
  linux-gnu) xdg-open "$1" ;;
  cygwin)    cygstart "$1" ;;
  esac
}

cd /srv
select repo in $(find -maxdepth 2 -name css | sed 's,./,,;s,/css,,')
do
  break
done
cd $repo

rm -rf _site
jekyll serve -w &

until [ -a _site ]
do
  sleep 1
done

browse .
browse http://127.0.0.1:4000
kill -7 $PPID
