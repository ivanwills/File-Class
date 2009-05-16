#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'File::Class' );
}

diag( "Testing File::Class $File::Class::VERSION, Perl $], $^X" );
