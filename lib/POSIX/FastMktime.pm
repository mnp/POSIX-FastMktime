package POSIX::FastMktime;

use 5.006;
use strict;
use warnings FATAL => 'all';
use POSIX qw(mktime);

our $VERSION = '0.01';

require Exporter;
our @ISA    = qw(Exporter);
our @EXPORT = qw(fast_mktime);

# This is the day and result cache.
my $mk_day = 0;
my $mk_mon = 0;
my $mk_year = 0;
my $mk_time = 0;

sub fast_mktime {
  my ($s, $m, $h, $day, $mon, $year) = @_;
  my $time;
  my $hmsarg = 3600 * $h + 60 * $m + $s;

  if ($hmsarg && $mk_day == $day && $mk_mon == $mon && $mk_year == $year) {
    $time = $mk_time + $hmsarg;
  }
  else {
    $mk_time = POSIX::mktime(0, 0, 0, $day, $mon, $year);
    $time = $mk_time ? $mk_time + $hmsarg : undef;
    $mk_day = $day;
    $mk_mon = $mon;
    $mk_year = $year;
  }

  return $time;
}

1;


=head1 NAME

POSIX::FastMktime - A drop-in mktime() replacement that's faster in
one specific but common, use case.

=head1 VERSION

Version 0.01

=cut

=head1 SYNOPSIS

    use POSIX::FastMktime;
    $time_t = POSIX::fast_mktime( 0, 30, 10, 12, 11, 95 );
    print "Date = ", POSIX::ctime($time_t);

=head1 ABSTRACT

Call it just like you would POSIX::mktime(), but with fast_mktime().

=head1 DESCRIPTION

Drop-in POSIX::mktime() replacement.  This is optimized for repeated
calls within the same date by caching previous result: if the cache
applies, it just performs the H:M:S calculation within the same day,
if not it falls through to POSIX::mktime() and stores the result for
next invocation.


=head1 EXPORT

fast_mkime()


=cut


=head1 SUBROUTINES/METHODS

There is only one function provided.

=item C<fast_mktime>

Given the same arguments as mktime(), sec, min, hour, etc., returns a
calendar time. If fast_mktime() was called before, and if the day
given is the same as the previous call, then 

Otherwise, the behavior will be the same as mktime().

=back


=head1 AUTHOR

Mitchell Perilstein, C<< <mnp at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-posix-fastmktime at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=POSIX-FastMktime>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc POSIX::FastMktime


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=POSIX-FastMktime>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/POSIX-FastMktime>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/POSIX-FastMktime>

=item * Search CPAN

L<http://search.cpan.org/dist/POSIX-FastMktime/>

=back


=head1 LICENSE AND COPYRIGHT

Copyright 2013 Mitchell Perilstein.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of POSIX::FastMktime
