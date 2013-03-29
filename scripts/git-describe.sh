# Fix broken git describe
# http://article.gmane.org/gmane.comp.version-control.git/210835

set $(git describe --tags)

tag=${1%-*-*}

sha=${1/*-}

set $(git log --oneline $tag..HEAD | wc -l)

echo ${tag}-${1}-${sha}
