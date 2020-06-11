#!/usr/bin/perl

use Test2::V0;
use Test2::Tools::Explain;
use Test2::Plugin::NoWarnings;
use Test2::API qw/intercept/;

use File::Temp;
use Test2::Tools::File;

require "./t/testutils.pl";

my ($fh,$handy_file) = File::Temp::tempfile;
close $fh;

my $events = intercept {
    file_exists_ok $handy_file;
    unlink $handy_file if -e $handy_file;
    bail_out("A file that should not exist still exists.") if -e $handy_file;
    file_exists_ok $handy_file;
};

like $events, t2_events(qw(Pass Fail)), "file_exists_ok: events";

done_testing;
