# Launch Jekyll

[ $OSTYPE = cygwin ] && xdg-open () {
  cygstart "$1"
}

usage () {
  echo usage: ${0##*/} REPO_NAME
  exit
}

(( $# )) || usage
cd /srv/$1
rm -rf _site
jekyll serve -w &

until [ -a _site ]
do
  sleep 1
done

xdg-open .
xdg-open http://127.0.0.1:4000
