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

        chmod(0700, $handy_file) or bail_out("Failed chmod tempfile for tesing");
        file_mode_isnt $handy_file, 0701; ## PASS
        file_mode_isnt $handy_file, 0700; ## FAIL

        chmod(0644, $handy_file) or bail_out("Failed chmod tempfile for tesing");
        file_mode_isnt $handy_file, 0645; ## PASS
        file_mode_isnt $handy_file, 0644; ## FAIL

        chmod(0100, $handy_file) or bail_out("Failed chmod tempfile for tesing");
        file_mode_isnt $handy_file, 0101; ## PASS
        file_mode_isnt $handy_file, 0100; ## FAIL

        {
            local $ENV{PRETEND_TO_BE_WIN32} = 1;
            file_mode_isnt $handy_file, 0100; ## SKIP
        }

        unlink $handy_file if -e $handy_file;
        bail_out("A file that should not exist still exists.") if -e $handy_file;

        # A nonexisting file does not match the mode
        file_mode_isnt $handy_file, 0100; ## PASS

    };

    like $events, t2_events(qw(Pass Fail Pass Fail Pass Fail Skip Pass)), "file_mode_isnt: events";

}

done_testing;
