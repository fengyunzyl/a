# Launch Jekyll
[ $OSTYPE = msys ] && xdg-open () {
  start $1
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

xdg-open .
xdg-open http://127.0.0.1:4000
