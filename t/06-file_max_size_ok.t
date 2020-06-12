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
    file_max_size_ok $handy_file, 0;  ## PASS
    ## it does not have size 2:
    file_max_size_ok $handy_file, 2;  ## PASS
    ## add 4 bytes:
    print $fh "\x00\x00\x00" or bail_out("Failed putting content in temp file");
    close $fh;
    ##
    file_max_size_ok $handy_file, 2;  ## FAIL
    file_max_size_ok $handy_file, 3;  ## PASS
    file_max_size_ok $handy_file, 0;  ## FAIL
    file_max_size_ok $handy_file, 1;  ## FAIL
    ## delete it:
    unlink $handy_file if -e $handy_file;
    bail_out("A file that should not exist still exists.") if -e $handy_file;
    file_max_size_ok $handy_file, 0;  ## FAIL
    file_max_size_ok $handy_file, 2;  ## FAIL
};

like $events, t2_events(qw(Pass Pass Fail Pass Fail Fail Fail Fail)), "file_max_size_ok: events";

done_testing;
