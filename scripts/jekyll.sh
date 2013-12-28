# Launch Jekyll

if [[ $OSTYPE =~ linux ]]
then
  XDG_OPEN=xdg-open
else
  XDG_OPEN="$WINDIR/system32/cmd /c start"
fi

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
