#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'GLSL::Preprocessor' ) || print "Bail out!\n";
}

diag( "Testing GLSL::Preprocessor $GLSL::Preprocessor::VERSION, Perl $], $^X" );
