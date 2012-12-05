#!/bin/bash
# Fix broken git describe
# http://article.gmane.org/gmane.comp.version-control.git/210835

read < <(git describe --tags)

tag=${REPLY%-*-*}

sha=${REPLY##*-}

read < <(git log --oneline $tag..HEAD | wc -l)

echo $tag-$REPLY-$sha
