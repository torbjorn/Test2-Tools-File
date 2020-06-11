use warnings;
use utf8;
use Carp;

use Test2::Tools::Compare;

sub t2_events {

    my @events = @_;

    return array {
        item event $_ for @events;
        end();
    }

}

1;
