#!/usr/bin/perl

use Test2::V0;
use Test2::Tools::Explain;
use Test2::Plugin::NoWarnings;
use Test2::API qw/intercept/;

use File::Temp;
use Test2::Tools::File;

require "./t/testutils.pl";

SKIP: {

    my ($fh,$handy_file) = File::Temp::tempfile;
    my ($fh2,$link_target) = File::Temp::tempfile;
    close $fh; close $fh2;

    # just go out on a limb to get something temp that does not exist
    unlink $link_target or bail_out("Failed setting up a link target for test");
    symlink $handy_file, $link_target;

    my $events = intercept {
        file_is_symlink_ok $link_target; ## PASS
        file_is_symlink_ok $handy_file;  ## FAIL
        unlink $handy_file if -e $handy_file;
        bail_out("A file that should not exist still exists.") if -e $handy_file;
        ## A symlink to a file gone is still a symlink
        file_is_symlink_ok $link_target; ## PASS
        unlink $link_target or bail_out("Failed removing symlink");
        file_is_symlink_ok $link_target; ## FAIL
    };

    like $events, t2_events(qw(Pass Fail Pass Fail)), "file_is_symlink_ok: events";

}

done_testing;
