use strict;
use warnings;

use Test::More;
use Test::Fatal;

use lib 't/lib';

sub rname {
  my $name = shift;
  $name =~ s/::/\//g;
  $name .= '.pm';
  return $name;
}

for (qw( Test::MyCmd Test::BrokenCmd Test::BrokenCmd::Command Test::IDONOTEXIST )) {
  ok( !exists $INC{ rname($_) }, "Module $_  is not loaded" );
  ok( !$_->isa("UNIVERSAL"),     "Module $_ is not ISA UNIVERSAL" );
}

for (qw( Test::MyCmd Test::BrokenCmd Test::BrokenCmd::Command Test::IDONOTEXIST )) {
  eval "require $_;1";
}

ok( exists $INC{ rname('Test::MyCmd') },              'Test::MyCmd existed' );
ok( exists $INC{ rname('Test::BrokenCmd') },          'Test::BrokenCmd existed' );
ok( exists $INC{ rname('Test::BrokenCmd::Command') }, 'Test::BrokenCmd::Command existed' );
ok( !exists $INC{ rname('Test::IDONOTEXIST') },       'Test::IDONOTEXIST did not exist' );

ok( 'Test::MyCmd'->isa("UNIVERSAL"),              'Test::MyCmd isa UNIVERSAL' );
ok( 'Test::BrokenCmd'->isa("UNIVERSAL"),          'Test::BrokenCmd isa UNIVERSAL' );
ok( 'Test::BrokenCmd::Command'->isa("UNIVERSAL"), 'Test::BrokenCmd::Command isa UNIVERSAL' );
ok( 'Test::IDONOTEXIST'->isa("UNIVERSAL"),        'Test::IDONOTEXIST isa UNIVERSAL' );

isnt( $INC{ rname('Test::MyCmd') }, undef, 'Things that actually work  are not undef' );
is( $INC{ rname($_) }, undef, 'Things that are broken(but exist) are undef :' . $_ )
  for qw( Test::BrokenCmd Test::BrokenCmd::Command );

for (qw( Test::BrokenCmd Test::BrokenCmd::Command Test::IDONOTEXIST )) {
  delete $INC{ rname($_) };
  isnt( eval "require $_;1", 1, "Broken deps should still die $_ " );
}

=begin

>=5.10

                   [ exists $INC ][ isa UNIVERSAL ][  $INC      ]
    Good Module    [    x        ][  x            ][    path    ]
    Bad Module     [    x        ][  x            ][    undef   ]
    Missing Module [             ][  x            ][    N/A     ]

<=5.9
                   [ exists $INC ][ isa UNIVERSAL ][  $INC      ]
    Good Module    [    x        ][  x            ][    path    ]
    Bad Module     [    x        ][  x            ][    path    ]
    Missing Module [             ][  x            ][    N/A     ]




=cut

done_testing;

