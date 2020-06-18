#!/usr/bin/perl

use Test2::V0;
use Test2::Tools::Explain;
use Test2::Plugin::NoWarnings;
use Test2::API qw/intercept/;

use File::Temp;
use Test2::Tools::File;

require "./t/testutils.pl";

SKIP: {

    my ( $fh , $handy_file  ) = File::Temp::tempfile;
    my ( $fh2, $link_target ) = File::Temp::tempfile;
    close $fh; close $fh2;

    unlink $link_target or bail_out("Failed setting up a link target for test");
    symlink $handy_file, $link_target;

    my $events = intercept {
        symlink_target_exists_ok $link_target; ## PASS
        symlink_target_exists_ok $handy_file;  ## SKIP

        unlink $handy_file
            or bail_out("A file that should not exist still exists.");

        symlink_target_exists_ok $link_target; ## FAIL

        unlink $link_target or bail_out("Failed removing symlink");
        symlink_target_exists_ok $link_target; ## FAIL

    };

    like $events, t2_events(qw(Pass Fail Fail Fail)), "symlink_target_exists_ok: events";

}

done_testing;
