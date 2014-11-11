#!awk -f
@include "readfile"
BEGIN {
  if (ARGC != 2) {
    print "highlight.awk FILE"
    exit
  }
  foo = readfile(ARGV[1])
  bar[++z] = "lang-php"
  bar[++z] = "lang-rb"
  bar[++z] = "lang-pl"
  bar[++z] = "lang-bash"
  bar[++z] = "lang-r"
  bar[++z] = "lang-c"
  bar[++z] = "lang-cl"
  bar[++z] = "lang-clj"
  bar[++z] = "lang-coffee"
  bar[++z] = "lang-cs"
  bar[++z] = "lang-css"
  bar[++z] = "lang-fs"
  bar[++z] = "lang-go"
  bar[++z] = "lang-hs"
  bar[++z] = "lang-html"
  bar[++z] = "lang-java"
  bar[++z] = "lang-js"
  bar[++z] = "lang-json"
  bar[++z] = "lang-latex"
  bar[++z] = "lang-lua"
  bar[++z] = "lang-pascal"
  bar[++z] = "lang-proto"
  bar[++z] = "lang-py"
  bar[++z] = "lang-rc"
  bar[++z] = "lang-scala"
  bar[++z] = "lang-sql"
  bar[++z] = "lang-vb"
  bar[++z] = "lang-vhdl"
  bar[++z] = "lang-xml"
  for (baz in bar)
    printf "%s\n\n<!-- language: %s -->\n\n%s\n", bar[baz], bar[baz], foo
}
