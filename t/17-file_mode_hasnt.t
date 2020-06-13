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

        chmod(0644, $handy_file) or bail_out("Failed chmod tempfile for tesing");
        file_mode_hasnt $handy_file, 0133; ## PASS
        file_mode_hasnt $handy_file, 0744; ## FAIL

        chmod(0700, $handy_file) or bail_out("Failed chmod tempfile for tesing");
        file_mode_hasnt $handy_file, 0077; ## PASS
        file_mode_hasnt $handy_file, 0544; ## FAIL

        {
            local $ENV{PRETEND_TO_BE_WIN32} = 1;
            file_mode_hasnt $handy_file, 0700; ## SKIP
        }

        unlink $handy_file if -e $handy_file;
        bail_out("A file that should not exist still exists.") if -e $handy_file;

        # A nonexisting file does not match the mode
        file_mode_hasnt $handy_file, 0700; ## FAIL

    };

    like $events, t2_events(qw(Pass Fail Pass Fail Skip Fail)), "file_mode_hasnt: events";

}

done_testing;
