package GLSL::Preprocessor;

use 5.12.0;
use warnings;

require Template;
require GLSL::Preprocessor::Template::Context;

=head1 NAME

GLSL::Preprocessor - GLSL source preprocessor using the Template Toolkit

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use GLSL::Preprocessor;

    my $foo = GLSL::Preprocessor->new();
    ...

=cut

sub new {
	my ($class, %opts) = @_;

	$Template::Config::CONTEXT = 'GLSL::Preprocessor::Template::Context';

	my $self = {
		_include_path => $opts{INCLUDE_PATH} // [],
		_template => Template->new({
			ABSOLUTE => 1,
			%opts}),
		_vars => {},
	};

	return bless $self, $class;
}

sub process {
	my ($self, $input_file, $output) = @_;
	my $tt = $self->{_template};

	$tt->process(
		$input_file,
		$self->{_vars},
		$output)
		or die $tt->error(), "\n"
}

sub get_deps {
	my ($self, $input_file) = @_;

	my $output = '';
	$self->process($input_file, \$output);

	$self->{_template}->context->get_included_files($self->{_include_path})
}

=head1 AUTHOR

Vincent Tavernier, C<< <vince.tavernier at gmail.com> >>


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc GLSL::Preprocessor


You can also look for information at:

=over 4

=item * GitHub repository for GLSL::Preprocessor (and issue tracker)

L<https://github.com/vtavernier/glsl-preprocessor>

=back


=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2019 by Vincent Tavernier.

This is free software, licensed under:

  The MIT License


=cut

1; # End of GLSL::Preprocessor
