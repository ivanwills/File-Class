#!/usr/bin/perl -w

BEGIN { $ENV{TESTING} = 1 }

use strict;
use warnings;
use Test::More tests => 14 + 1;
use Test::NoWarnings;
use Test::Exception;
use File::Spec;

use File::Class;

my $file = File::Class->new("/home/ivan/bin/");
isa_ok( $file, 'File::Class', 'Check that we correctly get an object' );
is( "$file", "/home/ivan/bin", 'That the outputted file matches the inputted one' );
is_deeply( $file->{file}, [qw/home ivan bin/], 'All the directories are stored correctly' );

$file = File::Class->new("/home/ivan/bin");
is( "$file", "/home/ivan/bin", 'That the outputted file matches the inputted one' );
is( $file->absolute, "/home/ivan/bin", 'The absolute version still matches the version with out absolute');

$file = File::Class->new([qw/home ivan bin/])->absolute(1);
is( "$file", "/home/ivan/bin", 'That the outputted file matches the inputted one' );

$file = File::Class->new($file);
is( "$file", "/home/ivan/bin", 'That the outputted file matches the inputted one' );

$file = File::Class->new( {abs => 1}, [qw/home ivan bin/]);
is( "$file", "/home/ivan/bin", 'That the outputted file matches the inputted one' );

$file = File::Class->new( {base => '/'}, [qw/home ivan bin/]);
is( "$file", "home/ivan/bin", 'That the outputted file matches the inputted relative one' );
is( $file->absolute, "/home/ivan/bin", 'That the outputted file matches the inputted one relative to the supplied base' );

dies_ok { File::Class->new({ file => 'bin' }) } 'Dies when it doesn\'t known what to do';

# Relative files
$file = File::Class->new('.');
ok( !$file->{absolute}, 'Check that the file is not an absolute file' );
is( "$file", '.', ' The file doesn\'t include leading /');
is( $file->absolute, File::Spec->rel2abs(File::Spec->curdir), 'We get the full path of the current dir' );
