#!/bin/sh
# How do I check if a file exists in a remote?
# stackoverflow.com/questions/4135049
# Bash: Iterating over lines in a variable
# superuser.com/questions/284187

git rev-list HEAD | while read rev; do
    printf '.'
    git ls-tree -rl $rev | while read blob; do
        array=($blob)
        size=${array[3]}
        name=${array[4]}
        git cat-file -e source:$name 2>/dev/null || {
            test $size -gt 100000 && printf "$name $size\n"
        }
    done
done
