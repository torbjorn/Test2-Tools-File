#!/usr/bin/perl

use Test2::V0;
use Test2::Tools::Explain;
use Test2::Plugin::NoWarnings;
use Test2::API qw/intercept/;

use File::Temp;
use Test2::Tools::File;
use File::chmod;
$File::chmod::UMASK = 0;

require "./t/testutils.pl";

SKIP: {

    skip "Superuser has special privileges", 1, if( $> == 0 or $< == 0 );

    my ($fh,$handy_file) = File::Temp::tempfile;
    close $fh;

    my $events = intercept {
        file_readable_ok $handy_file; ## PASS
        chmod("a-r", $handy_file) or bail_out("Failed removing read rights for tesing");
        file_readable_ok $handy_file; ## FAIL
        unlink $handy_file if -e $handy_file;
        bail_out("A file that should not exist still exists.") if -e $handy_file;
        ## A nonexisting file is simply not readable
        file_readable_ok $handy_file; ## FAIL
    };

    like $events, t2_events(qw(Pass Fail Fail)), "file_readable_ok: events";

}

done_testing;
