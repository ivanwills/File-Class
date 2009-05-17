#!/usr/bin/perl

use strict;
use warnings;
use File::Class;
use FindBin qw/$Bin $Script/;

# Create an object with the directory that this script was stored in
my $bin_dir = File::Class->new( $Bin );

# get the absolute current working directory
my $cwd = File::Class->cwd->absolute;

if ( "$bin_dir" eq "$cwd" ) {
	print "You are running this script form the directory it is stored in\n";
}
else {
	print "This script will change to $bin_dir to continue work\n";
	chdir $bin_dir;
}

my $script = File::Class->new( $Script );
if ( $script->does_exist ) {
	print "This file has not been deleted since running\n";
}
else {
	print "Your weird you appear to have delete this script\n";
}
