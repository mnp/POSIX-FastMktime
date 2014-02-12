#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Benchmark qw(:all);
use POSIX qw(mktime);
use Time::Local;
use POSIX::FastMktime;

if ( $ENV{RUN_BENCHMARKS} ) {
  plan tests => 1;
}
else {
  plan skip_all => "Benchmarks not required for installation; set RUN_BENCHMARKS if desired.";
}

my $sstart = time;
my $sstop  = $sstart + 1e7;
my @dates;

# Stuff a year of dates into an array.
for (my $s=$sstart; $s<$sstop; $s+=10) {
  push(@dates, [ (gmtime $s)[0..5] ]);
}

my $tmp;
my $results = timethese(5, {
    'POSIX::mktime'
        => sub { $tmp = POSIX::mktime(@$_)                  for @dates  },
    'TIME::Local::timegm_nocheck'
	=> sub { $tmp = Time::Local::timegm_nocheck(@$_)    for @dates  },
    'FastMktime::fast_mktime'
	=> sub { $tmp = POSIX::FastMktime::fast_mktime(@$_) for @dates  },
});

pass('benchmarks');
