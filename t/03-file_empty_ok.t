#!/usr/bin/perl

use Test2::V0;
use Test2::Tools::Explain;
use Test2::Plugin::NoWarnings;
use Test2::API qw/intercept/;

use File::Temp;
use Test2::Tools::File;

require "./t/testutils.pl";

my ($fh,$handy_file) = File::Temp::tempfile;

my $events = intercept {
    file_empty_ok $handy_file;
    ## make it not empty:
    print $fh "foo\n" or bail_out("Failed putting content in temp file");
    close $fh;
    file_empty_ok $handy_file;
    ## delete it:
    unlink $handy_file if -e $handy_file;
    bail_out("A file that should not exist still exists") if -e $handy_file;
    file_empty_ok $handy_file;
};

like $events, t2_events(qw(Pass Fail Fail)), "file_empty_ok: events";

done_testing;
