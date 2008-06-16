#!/usr/bin/perl

BEGIN {
	unshift @INC, "../lib"; 
	unshift @INC, "../blib/arch"; 
}

use Test::More tests => 34;

use Math::Int32 qw(int32 uint32 uint32_to_number
                   net_to_uint32 uint32_to_net
                   native_to_uint32 uint32_to_native);

my $i = uint32('1234567890');
my $j = $i + 1;
my $k = (uint32(1) << 60) + 255;

# 1
ok($i == '1234567890');

ok($j - 1 == '1234567890');

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

ok (int(log(uint32(1)<<50)/log(2)+0.001) == 18);

# 35
