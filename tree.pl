#!/bin/perl

$p = $ARGV[0];
$\ = "\n";

if (! $p) {
  print "usage: $0 package";
  exit;
}

open(
  MYFILE,
  glob("/usr/local/bin/http*/setup.ini")
);

while (<MYFILE>) {
  $k = $1 if /\@ (\S+)/;
  @r = split();
  shift @r;
  $r{$k} = [@r] if /requires:/;
}

@l = [$p, 0];

while ($p = pop @l) {
  next if $d{$$p[0]}++;
  print ' ' x $$p[1] . $$p[0];
  for $d (@{$r{$$p[0]}}) {
    push @l, [ $d,  $$p[1] + 1 ];
  }
}
