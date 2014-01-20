# Launch Jekyll

type xdg-open &>/dev/null || xdg-open () {
  # there are one or more whitespace characters
  # between the two quote characters
  cmd /c start '' "$1 "
}

usage () {
  echo usage: $0 REPO_NAME
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
