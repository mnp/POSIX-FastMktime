#!perl -T

# This test confirms both mktime and fast_mktime do what's expected
# and both give the same answer.

use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 19;
use POSIX qw(mktime);

BEGIN { use_ok( 'POSIX::FastMktime' ); }

sub ok_both {
  my ($args, $expect, $title) = @_;
  ok(fast_mktime(@$args) == $expect, "fast_mktime - " . $title);
  ok(mktime(@$args)      == $expect, "real mktime - " . $title);
}

ok(!defined fast_mktime(0, 0, 0, 0, 0, 0),	  "fast_mktime - zeros undef");
ok(!defined mktime(0, 0, 0, 0, 0, 0),		  "mktime - zeros undef");

ok(!defined fast_mktime(~0, ~0, ~0, ~0, ~0, ~0),  "fast_mktime - maxints undef");
ok(!defined mktime(~0, ~0, ~0, ~0, ~0, ~0),	  "mktime - maxints undef");

ok_both([39, 19, 20, 28,  5, 113], 1372465179, "sometime   Sat Jun 29 00:19:39 2013");
ok_both([40, 20, 21, 28,  5, 113], 1372468840, "same day   Sat Jun 29 01:20:40 2013");
ok_both([59, 59, 23, 29,  5, 113], 1372564799, "end of day Sun Jun 30 03:59:59 2013");
ok_both([0,   0,  0, 30,  5, 113], 1372564800, "next day   Sun Jun 30 04:00:00 2013");
ok_both([40, 20, 21, 29,  5, 113], 1372555240, "next day   Sun Jun 30 01:20:40 2013");
ok_both([0,   0, 19, 31, 11,  69],          0, "min epoch  Thu Jan  1 00:00:00 1970");
ok_both([59, 59, 18, 31, 11, 137], 2145916799, "max epoch  Thu Dec 31 23:59:59 2037");





