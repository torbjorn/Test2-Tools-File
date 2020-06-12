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
        file_not_writeable_ok $handy_file; ## FAIL
        chmod("a-w", $handy_file) or bail_out("Failed removing not_write rights for tesing");
        file_not_writeable_ok $handy_file; ## PASS
        unlink $handy_file if -e $handy_file;
        bail_out("A file that should not exist still exists.") if -e $handy_file;
        ## A nonexisting file is simply not not_writeable
        file_not_writeable_ok $handy_file; ## PASS
    };

    like $events, t2_events(qw(Fail Pass Pass)), "file_not_writeable_ok: events";

}

done_testing;
