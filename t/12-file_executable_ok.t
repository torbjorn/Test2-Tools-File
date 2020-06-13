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

    if ( Test2::Tools::File::_win32() ) {
        skip "file_executable_ok doesn't work on windows";
    }

    my ($fh,$handy_file) = File::Temp::tempfile;
    close $fh;

    my $events = intercept {
        chmod("a-x", $handy_file) or bail_out("Failed removing executable rights for tesing");
        file_executable_ok $handy_file; ## FAIL

        chmod("a+x", $handy_file) or bail_out("Failed setting executable rights for tesing");
        file_executable_ok $handy_file; ## PASS

        {
            local $ENV{PRETEND_TO_BE_WIN32} = 1;
            file_executable_ok $handy_file; ## SKIP
        }

        unlink $handy_file if -e $handy_file;
        bail_out("A file that should not exist still exists.") if -e $handy_file;
        ## A nonexisting file is not executable
        file_executable_ok $handy_file; ## FAIL
    };

    like $events, t2_events(qw(Fail Pass Skip Fail)), "file_executable_ok: events";




}

done_testing;
