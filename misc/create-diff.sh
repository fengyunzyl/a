#!/bin/sh
# Create diff without using Git
# jungels.net/articles/diff-patch-ten-minutes.html
# -u Output 3 lines of unified context.
# -w Ignore all white space. Optional.

diff -u a/Makefile b/Makefile > Makefile.diff
