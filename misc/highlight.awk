#!awk -f
@include "readfile"
BEGIN {
  if (ARGC != 2) {
    print "highlight.awk FILE"
    exit
  }
  foo = readfile(ARGV[1])
  bar = "                                                                     \
  default    lang-none lang-bash lang-c    lang-cs     lang-clj   lang-coffee \
  lang-css   lang-go   lang-hs   lang-html lang-java   lang-js    lang-json   \
  lang-latex lang-cl   lang-lua  lang-fs   lang-pascal lang-pl    lang-php    \
  lang-proto lang-py   lang-r    lang-rb   lang-rc     lang-scala lang-sql    \
  lang-vhdl  lang-vb   lang-xml                                               \
  "
  split(bar, baz)
  for (qux in baz)
    printf "%s\n\n<!-- language: %s -->\n\n%s\n", baz[qux], baz[qux], foo
}
