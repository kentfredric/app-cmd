#!perl
use strict;
use warnings;

use Test::More;# tests => 2;
use App::Cmd::Tester;

use lib 't/lib';

use Test::MySimple;

my $return = test_app('Test::MySimple', [ qw(--help) ]);

my $stdout = $return->stdout;
# When debugging, you can uncomment this to see exactly what help text
# is being printed.
# print STDERR "\n\nHELP TEXT:\n\n$stdout\n\n";
like(
    $stdout,
    qr/\S/,
    "Our simple app prints some help text.",
);

like(
    $stdout,
    qr/\[-f\]\s+\[long options\.\.\.\]/,
    "Our simple app prints a usage message",
);

my $option_help_regex = join('\s+', qw(-f --fooble check all foobs for foobling));

like(
    $stdout,
    qr/$option_help_regex/,
    "Our simple app prints the help text for --fooble option",
);

unlike(
    $stdout,
    qr/commands/i,
    "Our simple app doesn't talk about subcommands",
);

done_testing()
