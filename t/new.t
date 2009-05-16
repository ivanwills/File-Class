#!/usr/bin/perl -w

BEGIN { $ENV{TESTING} = 1 }

use strict;
use warnings;
use Test::More tests => 7 + 1;
use Test::NoWarnings;
use Test::Exception;

use File::Class;

my $file = File::Class->new("/home/ivan/bin/");
isa_ok( $file, 'File::Class', 'Check that we correctly get an object' );
is( "$file", "/home/ivan/bin", 'That the outputted file matches the inputted one' );
is_deeply( $file->{file}, [qw/home ivan bin/], 'All the directories are stored correctly' );

$file = File::Class->new("/home/ivan/bin");
is( "$file", "/home/ivan/bin", 'That the outputted file matches the inputted one' );

$file = File::Class->new([qw/home ivan bin/]);
is( "$file", "/home/ivan/bin", 'That the outputted file matches the inputted one' );

$file = File::Class->new($file);
is( "$file", "/home/ivan/bin", 'That the outputted file matches the inputted one' );

dies_ok { File::Class->new({ file => 'bin' }) } 'Dies when it doesn\'t known what to do';
