#!/usr/bin/perl -w

BEGIN { $ENV{TESTING} = 1 }

use strict;
use warnings;
use Test::More tests => 10 + 1;
use Test::NoWarnings;
use Test::Exception;

use File::Class;

my $file = File::Class->new('/home/ivan/bin');
is( $file->up, '/home/ivan', 'Can successfully get the parent directry' );
is( $file->up(2), '/home', 'Can successfully get the grandparent directry' );

is( $file->up + 'bin', '/home/ivan/bin', 'Can successfuly add a file to the path' );
is( $file->up + ['bin'], '/home/ivan/bin', 'Can successfuly add a file to the path' );
is( $file->up + File::Class->new('bin'), '/home/ivan/bin', 'Can successfuly add a file to the path' );
dies_ok { $file + { file => 'bin' } } 'Dies when it doesn\'t known what to do';

$file = File::Class->new('home/ivan/bin');
TODO: {
	local $TODO = "Need to make sure that up works with relative files if there is enough directories";
	is( $file->up, 'home/ivan', 'Can successfully get the parent directry' );
}

$file = File::Class->cwd;
ok( $file->is_dir, 'Check that when we try the current working dir we get a directory' );
ok(!$file->is_file, ' That it isn\'t a file' );
ok( $file->does_exist, ' But should also exist' );
