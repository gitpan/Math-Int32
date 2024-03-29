package Math::Int32;

use strict;
use warnings;

BEGIN {
    our $VERSION = '0.03';

    require XSLoader;
    XSLoader::load('Math::Int32', $VERSION);
}

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(int32
                    int32_to_number
                    net_to_int32 int32_to_net
                    native_to_int32 int32_to_native
                    uint32
                    uint32_to_number
                    net_to_uint32 uint32_to_net
                    native_to_uint32 uint32_to_native);


use overload ( '+' => \&_add,
               '+=' => \&_add,
               '-' => \&_sub,
               '-=' => \&_sub,
               '*' => \&_mul,
               '*=' => \&_mul,
               '/' => \&_div,
               '/=' => \&_div,
               '%' => \&_rest,
               '%=' => \&_rest,
               'neg' => \&_neg,
               '++' => \&_inc,
               '--' => \&_dec,
               '!' => \&_not,
               '~' => \&_bnot,
               '&' => \&_and,
               '|' => \&_or,
               '^' => \&_xor,
               '<<' => \&_left,
               '>>' => \&_right,
               '<=>' => \&_spaceship,
               '>' => \&_gtn,
               '<' => \&_ltn,
               '>=' => \&_gen,
               '<=' => \&_len,
               '==' => \&_eqn,
               '!=' => \&_nen,
               'bool' => \&_bool,
               '0+' => \&_number,
               '""' => \&_string,
               '=' => \&_clone,
               fallback => 1 );

package Math::UInt32;
use overload ( '+' => \&_add,
               '+=' => \&_add,
               '-' => \&_sub,
               '-=' => \&_sub,
               '*' => \&_mul,
               '*=' => \&_mul,
               '/' => \&_div,
               '/=' => \&_div,
               '%' => \&_rest,
               '%=' => \&_rest,
               'neg' => \&_neg,
               '++' => \&_inc,
               '--' => \&_dec,
               '!' => \&_not,
               '~' => \&_bnot,
               '&' => \&_and,
               '|' => \&_or,
               '^' => \&_xor,
               '<<' => \&_left,
               '>>' => \&_right,
               '<=>' => \&_spaceship,
               '>' => \&_gtn,
               '<' => \&_ltn,
               '>=' => \&_gen,
               '<=' => \&_len,
               '==' => \&_eqn,
               '!=' => \&_nen,
               'bool' => \&_bool,
               '0+' => \&_number,
               '""' => \&_string,
               '=' => \&_clone,
               fallback => 1 );

1;

__END__

=head1 NAME

Math::Int32 - Manipulate 32 bits integers in Perl

=head1 SYNOPSIS

  use Math::Int32 qw(int32);

  my $i = int32(1);
  my $j = $i << 40;
  my $k = int32("12345678901234567890");
  print($i + $j * 1000000);


=head1 DESCRIPTION

This module adds support for 32 bit integers, signed and unsigned, to
Perl.

=head2 EXPORTABLE FUNCTIONS

=over 4

=item int32()

=item int32($value)

Creates a new int32 value and initializes it to C<$value>, where
$value can be a Perl number or a string containing a number.

For instance:

  $i = int32(34);
  $j = int32("-123454321234543212345");

  $k = int32(1234567698478483938988988); # wrong!!!
                                         #  the unquoted number would
                                         #  be converted first to a
                                         #  real number causing it to
                                         #  loose some precision.

Once the int32 number is created it can be manipulated as any other
Perl value supporting all the standard operations (addition, negation,
multiplication, postincrement, etc.).


=item net_to_int32($str)

Converts an 8 bytes string containing an int32 in network order to the
internal representation used by this module.

=item int32_to_net($int32)

Returns an 8 bytes string with the representation of the int32 value
in network order.

=item native_to_int32($str)

=item int32_to_native($int32)

similar to net_to_int32 and int32_to_net, but using the native CPU
order.

=item int32_to_number($int32)

returns the optimum representation of the int32 value using Perl
internal types (IV, UV or NV). Precision could be lost.

For instance:

  for my $l (10, 20, 30, 40, 50, 60) {
    my $i = int32(1) << $l;
    my $n = int32_to_number($i);
    print "int32:$i => perl:$n\n";
  }


=item uint32

=item uint32_to_number

=item net_to_uint32

=item uint32_to_net

=item native_to_uint32

=item uint32_to_native

These functions are similar to their int32 counterparts, but
manipulate 32 bit unsigned integers.

=back

=head1 BUGS AND SUPPORT

At this moment, this module requires int32 support from the C
compiler. Also, it doesn't take any advantage of perls with 32 bit IVs.

For bug reports, feature requests or just help using this module, use
the RT system at L<http://rt.cpan.org> or send my and email or both!

=head1 SEE ALSO

Other modules that allow Perl to support larger integers or numbers
are L<Math::BigInt>, L<Math::BigRat> and L<Math::Big>,
L<Math::BigInt::BitVect>, L<Math::BigInt::Pari> and
L<Math::BigInt::GMP>.

=head1 AUTHOR

Salvador FandiE<ntilde>o, E<lt>sfandino@yahoo.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by Salvador FandiE<ntilde>o

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
