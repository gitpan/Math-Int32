
use ExtUtils::MakeMaker;

use Config;

my $backend;

if ($Config::Config{ivsize} == 8) {
    $backend = 'NATIVE';
}
elsif ($Config::Config{doublesize} == 8) {
    $backend = 'DOUBLE';
}
else {
    $backend = 'STRING';
}

# we force the DOUBLE backend for the moment...
$backend = 'DOUBLE';

unless ($Config::Config{i32type} and
        #$Config::Config{d_int32_t} and
        $Config::Config{i32size} == 4) {
    die "Your C compiler does not have enough support for int32 values\n";
}

my @define = ("INT32_BACKEND_" . $backend);

for (qw(strtoll strtoull atoll atoull)) {
    push @define, "INT32_HAS_" . uc $_
        if $Config::Config{"d_$_"};
}

my $define = join (' ', map { "-D$_" } @define);

WriteMakefile( NAME              => 'Math::Int32',
               VERSION_FROM      => 'lib/Math/Int32.pm',
               PREREQ_PM         => {},
               ABSTRACT_FROM  => 'lib/Math/Int32.pm', # retrieve abstract from module
               AUTHOR         => 'Salvador Fandino <sfandino@yahoo.com>',
               LIBS              => [''], # e.g., '-lm'
               DEFINE            => $define,
               INC               => '-I.', # e.g., '-I. -I/usr/include/other'
);
