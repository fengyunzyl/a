#!/bin/bash
# Fix broken git describe
# http://article.gmane.org/gmane.comp.version-control.git/210835

read aa < <(git describe --tags)

tag=${aa%-*-*}

sha=${aa/*-}

read bb < <(git log --oneline $tag..HEAD | wc -l)

echo $tag-$bb-$sha
