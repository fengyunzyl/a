#!/usr/bin/awk -f
@include "readfile"
BEGIN {
  if (ARGC != 2) {
    print "highlight.awk FILE"
    exit
  }
  foo = readfile(ARGV[1])
  bar[++z] = "lang-php"
  bar[++z] = "lang-ruby"
  bar[++z] = "lang-perl"
  bar[++z] = "lang-bash"
  bar[++z] = "lang-r"
  bar[++z] = "lang-lisp"
  bar[++z] = "lang-c"
  bar[++z] = "lang-cs"
  bar[++z] = "lang-css"
  bar[++z] = "lang-html"
  bar[++z] = "lang-js"
  bar[++z] = "lang-json"
  bar[++z] = "lang-latex"
  bar[++z] = "lang-python"
  bar[++z] = "lang-sql"
  bar[++z] = "lang-xml"
  for (baz in bar)
    printf "%s\n\n<!-- language: %s -->\n\n%s\n", bar[baz], bar[baz], foo
}
