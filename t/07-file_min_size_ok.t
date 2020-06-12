#!/usr/bin/perl

use Test2::V0;
use Test2::Tools::Explain;
use Test2::Plugin::NoWarnings;
use Test2::API qw/intercept/;

use File::Temp;
use Test2::Tools::File;

require "./t/testutils.pl";

my ($fh,$handy_file) = File::Temp::tempfile;
binmode($fh);

my $events = intercept {
    ## empty file has size 0
    file_min_size_ok $handy_file, 0;  ## PASS
    ## it does not have size 2:
    file_min_size_ok $handy_file, 2;  ## FAIL
    ## add 4 bytes:
    print $fh "\x00\x00" or bail_out("Failed putting content in temp file");
    close $fh;
    ##
    file_min_size_ok $handy_file, 2;  ## PASS
    file_min_size_ok $handy_file, 0;  ## PASS
    file_min_size_ok $handy_file, 1;  ## PASS
    file_min_size_ok $handy_file, 3;  ## FAIL
    ## delete it:
    unlink $handy_file if -e $handy_file;
    bail_out("A file that should not exist still exists.") if -e $handy_file;
    file_min_size_ok $handy_file, 0;  ## DIAG + FAIL
    file_min_size_ok $handy_file, 3;  ## DIAG + FAIL
};

like(
    $events,
    t2_events(qw(
                    Pass Fail Pass Pass Pass Fail
                    Diag Fail Diag Fail
            )),
    "file_min_size_ok: events"
);

done_testing;
