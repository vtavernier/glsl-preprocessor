package GLSL::Preprocessor::Template::Context;

# Based on Template::Timer

use 5.12.00;
use warnings;

use base qw/Template::Context/;

require File::Spec;
require List::Util;
require List::Uniq;

our @_included_files;

foreach my $sub (qw/ process insert include /) {
	no strict;
	my $super = __PACKAGE__->can("SUPER::$sub") or die;
	*{$sub} = sub {
		my $self = shift;
		my $template = $_[0];

		unless (ref($template) eq 'ARRAY') {
			$template = [$template];
		}

		for my $t (@$template) {
			if (ref($t) eq 'Template::Document') {
				# The template being processed, no need to log it
			} else {
				push @_included_files, $t;
			}
		}

		return $super->($self, @_);
	};
}

sub get_included_files {
	my ($self, $include_path) = @_;

	# Resolve filenames manually
	my @files = map {
		my $fn = $_;
		if (File::Spec->file_name_is_absolute($fn)) {
			$fn
		} else {
			List::Util::first { -f } (map { File::Spec->catfile($_, $fn) } @$include_path)
		}
	} @_included_files;

	@_included_files = ();

	return [ List::Uniq::uniq(@files) ]
}

1;
