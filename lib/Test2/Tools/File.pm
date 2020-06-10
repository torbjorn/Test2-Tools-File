package Test2::Tools::File;

# ABSTRACT: Exports test functions for files and directories

use strict;
use warnings;

use Test2::API qw/context/;

use base 'Exporter';
our @EXPORT = qw/ file_exists_ok file_not_exists_ok file_empty_ok
                  file_not_empty_ok file_size_ok file_max_size_ok
                  file_min_size_ok file_readable_ok
                  file_not_readable_ok file_writeable_ok
                  file_not_writeable_ok file_executable_ok
                  file_not_executable_ok file_mode_is file_mode_isnt
                  file_mode_has file_mode_hasnt file_is_symlink_ok
                  symlink_target_exists_ok symlink_target_is
                  symlink_target_dangles_ok dir_exists_ok
                  dir_contains_ok link_count_is_ok link_count_gt_ok
                  link_count_lt_ok owner_is owner_isnt group_is
                  group_isnt file_line_count_is file_line_count_isnt
                  file_line_count_between file_contains_like
                  file_contains_unlike file_contains_utf8_like
                  file_contains_utf8_unlike file_contains_encoded_like
                  file_contains_encoded_unlike file_mtime_gt_ok
                  file_mtime_lt_ok file_mtime_age_ok /;

sub file_exists_ok($;$@) {

    my($filename,$name,@diag) = @_;
    $name //= "$filename exists";

    my $ctx = context();

    return $ctx->pass_and_release($name) if -e $filename;

    return $ctx->fail_and_release($name,@diag);

}

sub file_not_exists_ok{

    my($filename,$name,@diag) = @_;
    $name //= "$filename doesn't exist";

    my $ctx = context();

    return $ctx->pass_and_release($name) if not -e $filename;
    return $ctx->fail_and_release($name,@diag);

}

sub file_empty_ok{



}

sub file_not_empty_ok{
}

sub file_size_ok{
}

sub file_max_size_ok{
}

sub file_min_size_ok{
}

sub file_readable_ok{
}

sub file_not_readable_ok{
}

sub file_writeable_ok{
}

sub file_not_writeable_ok{
}

sub file_executable_ok{
}

sub file_not_executable_ok{
}

sub file_mode_is{
}

sub file_mode_isnt{
}

sub file_mode_has{
}

sub file_mode_hasnt{
}

sub file_is_symlink_ok{
}

sub symlink_target_exists_ok{
}

sub symlink_target_is{
}

sub symlink_target_dangles_ok{
}

sub dir_exists_ok{
}

sub dir_contains_ok{
}

sub link_count_is_ok{
}

sub link_count_gt_ok{
}

sub link_count_lt_ok{
}

sub owner_is{
}

sub owner_isnt{
}

sub group_is{
}

sub group_isnt{
}

sub file_line_count_is{
}

sub file_line_count_isnt{
}

sub file_line_count_between{
}

sub file_contains_like{
}

sub file_contains_unlike{
}

sub file_contains_utf8_like{
}

sub file_contains_utf8_unlike{
}

sub file_contains_encoded_like{
}

sub file_contains_encoded_unlike{
}

sub file_mtime_gt_ok{
}

sub file_mtime_lt_ok{
}

sub file_mtime_age_ok{
}



1;

__END__

=encoding utf8
