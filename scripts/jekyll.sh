# Launch Jekyll

case $OSTYPE in
linux-gnu) XDG_OPEN=xdg-open       ;;
   cygwin) XDG_OPEN='cmd /c start' ;;
esac

usage ()
{
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

$XDG_OPEN .
$XDG_OPEN http://127.0.0.1:4000
