use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
	module_name         => 'File::Class',
	license             => 'perl',
	dist_author         => 'Ivan Wills <ivan.wills@gmail.com>',
	dist_version_from   => 'lib/File/Class.pm',
	requires            => {
		'version'      => 0,
		'Carp'         => 0,
		'Scalar::Util' => 0,
		'Data::Dumper' => 0,
		'Clone'        => 0,
		'File::Spec'   => 0,
		'overload'     => 0,
	},
	build_requires => {
		'Test::More'       => 0,
		'Test::Exception'  => 0,
		'Test::NoWarnings' => 0,
	},
	add_to_cleanup     => [ 'File-Class-*' ],
	create_makefile_pl => 'traditional',
	create_license     => 1,
);

$builder->create_build_script();
