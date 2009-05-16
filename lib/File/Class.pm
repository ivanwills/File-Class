package File::Class;

# Created on: 2009-05-16 18:41:14
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use strict;
use warnings;
use version;
use Carp;
use Scalar::Util qw/blessed/;
use Data::Dumper qw/Dumper/;
use English qw/ -no_match_vars /;
use base qw/Exporter/;
use Clone qw/clone/;
use File::Spec;
use overload
	'""' => \&to_string,
	'+'  => \&add;

our $VERSION     = version->new('0.0.1');
our @EXPORT_OK   = qw//;
our %EXPORT_TAGS = ();

sub new {
	my ($class, $file) = @_;
	my $self  = {};

	bless $self, $class;

	if ( ref $file eq 'ARRAY' ) {
		my ($volume, $dir, $file_name) = File::Spec->splitpath( File::Spec->catfile(@{ $file }) );
		$self->{volume} = $volume;
		$self->{file}   = [ grep {$_} File::Spec->splitdir($dir) ];
		push @{ $self->{file} }, $file_name if $file_name;
	}
	elsif ( blessed $file && $file->isa($class) ) {
		$self->{volume} = $file->{volume};
		$self->{file}   = $file->{file};
	}
	elsif ( !ref $file ) {
		my ($volume, $dir, $file_name) = File::Spec->splitpath($file);
		$self->{volume} = $volume;
		$self->{file}   = [ grep {$_} File::Spec->splitdir($dir) ];
		push @{ $self->{file} }, $file_name if $file_name;
	}
	else {
		croak "Unknown path $file";
	}

	return $self;
}

sub to_string {
	my ($self) = @_;

	return File::Spec->catfile( $self->{volume}, @{ $self->{file} } );
}

sub up {
	my ( $self, $num ) = @_;
	$num ||= 1;

	my $new_file = clone $self;

	for (1 .. $num) {
		pop @{ $new_file->{file} };
	}

	return $new_file;
}

sub add {
	my ( $self, $path ) = @_;
	my $new_file = clone $self;

	if (ref $path eq 'ARRAY') {
		my ($volume, $dir, $file_name) = File::Spec->splitpath( File::Spec->catfile(@{ $path }) );
		my @path = grep {$_} File::Spec->splitdir($dir);
		push @path, $file_name if $file_name;
		push @{ $new_file->{file} }, @path;
	}
	elsif ( blessed $path && $path->isa(ref $self) ) {
		push @{ $new_file->{file} }, @{ $path->{file} };
	}
	elsif ( !ref $path ) {
		my ($volume, $dir, $file_name) = File::Spec->splitpath($path);
		my @path = grep {$_} File::Spec->splitdir($dir);
		push @path, $file_name if $file_name;
		push @{ $new_file->{file} }, @path;
	}
	else {
		croak "Unknown path $path";
	}

	return $new_file;
}

sub is_dir {
	my ($self) = @_;

	return -d "$self";
}

sub is_file {
	my ($self) = @_;

	return -f "$self";
}

sub does_exist {
	my ($self) = @_;

	return -f "$self";
}

1;

__END__

=head1 NAME

File::Class - Simplifies handling of files in a portable way (Hopefully :-) )

=head1 VERSION

This documentation refers to File::Class version 0.1.


=head1 SYNOPSIS

   use File::Class;

   # create a new file object
   my $path = File::Class->new( '/home/ivan/bin/' );

   # add a path to the file
   my $file = $path + 'firefox-3';
   # $file = '/home/ivan/bin/firefox-3';

   # get the parent directory
   print $file->up;
   # prints '/home/ivan/bin'

=head1 DESCRIPTION



=head1 SUBROUTINES/METHODS

=head3 C<new ( $search, )>

Param: C<$search> - type (detail) - description

Return: File::Class -

Description:

=head3 C<to_string ()>

Return: string - The string version of the file

Description: Stringifies the file.

=head3 C<up ([$num])>

Param: C<$num> - int - Number of levels to go up

Return: File::Class - an object of the ancestor directory

Description: Gets the parent/ancestor directory of the current file or directory

=head3 C<add ( $str | $array_ref )>

Param: C<$str> - string - A file path to add to the end of the current file

Param: C<$array_ref> - array ref - A list of directories and a file to add to the end of the current file

Return: File::Class - A new file with the extra path added to it.

Description: Adds a path to the current file.

=head3 C<is_dir ()>

Return: bool - True if the object represents a directory on the file system

=head3 C<is_file ()>

Return: bool - True if the object represents and ordinary file on the file system

=head3 C<does_exist ()>

Return: bool - True if the object exists on the file system

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

There are no known bugs in this module.

Please report problems to Ivan Wills (ivan.wills@gmail.com).

Patches are welcome.

=head1 AUTHOR

Ivan Wills - (ivan.wills@gmail.com)

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2009 Ivan Wills (14 Mullion Close Hornsby Heights, NSW, Australia 2077).
All rights reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. See L<perlartistic>.  This program is
distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

=cut
