#!/usr/bin/perl

BEGIN {
	unshift @INC, "../lib"; 
	unshift @INC, "../blib/arch"; 
}

use Test::More tests => 40;

use Math::Int32 qw(int32 int32_to_number
                   net_to_int32 int32_to_net
                   native_to_int32 int32_to_native);

my $i = int32('123456789');
my $j = $i + 1;
my $k = (int32(1) << 60) + 255;

my $m = int32(-1);
print $m, "\n";
print $m-1, "\n";
print int32_to_net($m), "\n";

# 1
ok($i == '123456789');

ok($j - 1 == '123456789');

ok (($k & 127) == 127);

ok (($k & 256) == 0);

# 5
ok ($i * 2 == $j + $j - 2);

ok ($i * $i * $i * $i == ($j * $j - 2 * $j + 1) * ($j * $j - 2 * $j + 1));

ok (($i / $j) == 0);

ok ($j / $i == 1);

ok ($i % $j == $i);

# 10
ok ($j % $i == 1);

ok (($j += 1) == $i + 2);

ok ($j == $i + 2);

ok (($j -= 3) == $i - 1);

ok ($j == $i - 1);

$j = $i;
# 15
ok (($j *= 2) == $i << 1);

ok (($j >> 1) == $i);

ok (($j / 2) == $i);

$j = $i + 2;

ok (($j %= $i) == 2);

ok ($j == 2);

# 20
ok (($j <=> $i) < 0);

ok (($i <=> $j) > 0);

ok (($i <=> $i) == 0);

ok (($j <=> 2) == 0);

ok ($j < $i);

# 25
ok ($j <= $i);

ok (!($i < $j));

ok (!($i <= $j));

ok ($i <= $i);

ok ($j >= $j);

# 30
ok ($i > $j);

ok ($i >= $j);

ok (!($j > $i));

ok (!($j >= $i));

ok (int(log(int32(1)<<50)/log(2)+0.001) == 18);

# 35

my $n = int32_to_net(-1);
ok (join(" ", unpack "C*" => $n) eq join(" ", (255) x 4));

ok (net_to_int32($n) == -1);

ok (native_to_int32(int32_to_native(-1)) == -1);

ok (native_to_int32(int32_to_native(0)) == 0);

ok (native_to_int32(int32_to_native(-12343)) == -12343);

# 40

$n = pack(N => 0x01020304);

ok (net_to_int32($n) == int32(0x01020304));

