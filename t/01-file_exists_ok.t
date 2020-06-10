#!/usr/bin/perl

use Test2::V0;
use Test2::Tools::Explain;
use Test2::Plugin::NoWarnings;
use Test2::API qw/intercept/;

use File::Temp;
use Test2::Tools::File;

use Carp;

my ($fh,$handy_file) = File::Temp::tempfile;
close $fh;

my $events = intercept {
    file_exists_ok( $handy_file );
    unlink $handy_file if -e $handy_file;
    croak "a file that should not exist still exists." if -e $handy_file;
    file_exists_ok( $handy_file );
};

is @$events, 2, "correctly produces two test results";
ok $events->[0]->facet_data->{assert}{pass}, "first is a pass";
ok !$events->[1]->facet_data->{assert}{pass}, "second is a fail";

done_testing;
