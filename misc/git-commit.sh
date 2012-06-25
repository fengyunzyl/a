#!/bin/sh
# Make a commit with correct author and date

echo 'Enter commit author, e.g. KSV <faltuvisitor@yahoo.co.in>'
read author

echo
echo 'Enter path to file with timestamp, or'
echo 'Enter date, e.g. 2012-04-26 14:56:20 +0000'
read -r author_date
test -e "$author_date" && {
    author_date=$(date -Rud "$(stat -c %y $author_date)")
    echo $author_date
}

# Commit, assume we are in repo dir
git add -A
git commit --author "$author" --date "$author_date"
