#!/usr/bin/perl

use Test2::V0;
use Test2::Tools::Explain;
use Test2::Plugin::NoWarnings;
use Test2::API qw/intercept/;

use File::Temp;
use Test2::Tools::File;

use Carp;

my ($fh,$handy_file) = File::Temp::tempfile;

my $events = intercept {
    file_empty_ok $handy_file;
    ## make it not empty:
    print $fh "foo\n" or croak "Failed putting content in temp file";
    close $fh;
    file_empty_ok $handy_file;
    ## delete it:
    unlink $handy_file if -e $handy_file;
    croak "a file that should not exist still exists." if -e $handy_file;
    file_empty_ok $handy_file;
};

is @$events, 4, "file_empty_ok: 3 events produced";
ok  $events->[0]->facet_data->{assert}{pass}, "first is a pass";
ok !$events->[1]->facet_data->{assert}{pass}, "second is a fail";
is  $events->[2]->facet_data->{info}[0]{tag}, "DIAG", "third is a diagnostic on missing file";
ok !$events->[3]->facet_data->{assert}{pass}, "fourth is a fail due to missing file";

done_testing;
