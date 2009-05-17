#!/usr/bin/perl -w

BEGIN { $ENV{TESTING} = 1 }

use strict;
use warnings;
use Test::More tests => 8 + 1;
use Test::NoWarnings;
use Test::Exception;

use File::Class;

my $file = File::Class->new('/home/ivan/bin');
is( $file->up, '/home/ivan', 'Can successfully get the parent directry' );

is( $file->up + 'bin', '/home/ivan/bin', 'Can successfuly add a file to the path' );
is( $file->up + ['bin'], '/home/ivan/bin', 'Can successfuly add a file to the path' );
is( $file->up + File::Class->new('bin'), '/home/ivan/bin', 'Can successfuly add a file to the path' );
dies_ok { $file + { file => 'bin' } } 'Dies when it doesn\'t known what to do';

$file = File::Class->cwd;
ok( $file->is_dir, 'Check that when we try the current working dir we get a directory' );
ok(!$file->is_file, ' That it isn\'t a file' );
ok( $file->does_exist, ' But should also exist' );
