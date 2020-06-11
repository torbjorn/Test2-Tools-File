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

sub file_not_exists_ok($;$@) {

    my($filename,$name,@diag) = @_;
    $name //= "$filename doesn't exist";

    my $ctx = context();

    return $ctx->pass_and_release($name) if not -e $filename;
    return $ctx->fail_and_release($name,@diag);

}

sub file_empty_ok($;$@) {

    my($filename,$name,@diag) = @_;
    $name //= "$filename is empty";

    my $ctx = context();

    if (not -e $filename) {
        $ctx->diag("File [$filename] tested for being empty, but it does not exist");
        return $ctx->fail_and_release($name,@diag);
    }

    return $ctx->pass_and_release($name) if -z $filename;
    return $ctx->fail_and_release($name,@diag);

}

sub file_not_empty_ok($;$@) {
    my($filename,$name,@diag) = @_;
    $name //= "$filename is not empty";

    my $ctx = context();

    if (not -e $filename) {
        $ctx->diag("File [$filename] tested for being empty, but it does not exist");
        return $ctx->fail_and_release($name,@diag);
    }

    return $ctx->pass_and_release($name) if not -z $filename;

    @diag=("File [$filename] exists with zero size!");
    return $ctx->fail_and_release($name,@diag);

}

sub file_size_ok($$;$@) {
    my($filename,$expected,$name,@diag) = @_;

    $expected = int $expected;
    $name //= "$filename has right size";

    my $ctx = context();

    if (not -e $filename) {
        $ctx->diag("File [$filename] does not exist");
        return $ctx->fail_and_release($name,@diag);
    }

    return $ctx->pass_and_release($name) if -s $filename == $expected;
    return $ctx->fail_and_release($name,@diag);

}

sub file_max_size_ok($;$@) {
    my($filename,$name,@diag) = @_;


}

sub file_min_size_ok($;$@) {
    my($filename,$name,@diag) = @_;


}

sub file_readable_ok($;$@) {
    my($filename,$name,@diag) = @_;


}

sub file_not_readable_ok($;$@) {
    my($filename,$name,@diag) = @_;


}

sub file_writeable_ok($;$@) {
    my($filename,$name,@diag) = @_;


}

sub file_not_writeable_ok($;$@) {
    my($filename,$name,@diag) = @_;


}

sub file_executable_ok($;$@) {
    my($filename,$name,@diag) = @_;


}

sub file_not_executable_ok($;$@) {
    my($filename,$name,@diag) = @_;


}

sub file_mode_is($;$@) {
    my($filename,$name,@diag) = @_;


}

sub file_mode_isnt($;$@) {
    my($filename,$name,@diag) = @_;


}

sub file_mode_has($;$@) {
    my($filename,$name,@diag) = @_;


}

sub file_mode_hasnt($;$@) {
    my($filename,$name,@diag) = @_;


}

sub file_is_symlink_ok($;$@) {
    my($filename,$name,@diag) = @_;


}

sub symlink_target_exists_ok($;$@) {
    my($filename,$name,@diag) = @_;


}

sub symlink_target_is($;$@) {
    my($filename,$name,@diag) = @_;


}

sub symlink_target_dangles_ok($;$@) {
    my($filename,$name,@diag) = @_;


}

sub dir_exists_ok($;$@) {
    my($filename,$name,@diag) = @_;


}

sub dir_contains_ok($;$@) {
    my($filename,$name,@diag) = @_;


}

sub link_count_is_ok($;$@) {
    my($filename,$name,@diag) = @_;


}

sub link_count_gt_ok($;$@) {
    my($filename,$name,@diag) = @_;


}

sub link_count_lt_ok($;$@) {
    my($filename,$name,@diag) = @_;


}

sub owner_is($;$@) {
    my($filename,$name,@diag) = @_;


}

sub owner_isnt($;$@) {
    my($filename,$name,@diag) = @_;


}

sub group_is($;$@) {
    my($filename,$name,@diag) = @_;


}

sub group_isnt($;$@) {
    my($filename,$name,@diag) = @_;


}

sub file_line_count_is($;$@) {
    my($filename,$name,@diag) = @_;


}

sub file_line_count_isnt($;$@) {
    my($filename,$name,@diag) = @_;


}

sub file_line_count_between($;$@) {
    my($filename,$name,@diag) = @_;


}

sub file_contains_like($;$@) {
    my($filename,$name,@diag) = @_;


}

sub file_contains_unlike($;$@) {
    my($filename,$name,@diag) = @_;


}

sub file_contains_utf8_like($;$@) {
    my($filename,$name,@diag) = @_;


}

sub file_contains_utf8_unlike($;$@) {
    my($filename,$name,@diag) = @_;


}

sub file_contains_encoded_like($;$@) {
    my($filename,$name,@diag) = @_;


}

sub file_contains_encoded_unlike($;$@) {
    my($filename,$name,@diag) = @_;


}

sub file_mtime_gt_ok($;$@) {
    my($filename,$name,@diag) = @_;


}

sub file_mtime_lt_ok($;$@) {
    my($filename,$name,@diag) = @_;


}

sub file_mtime_age_ok($;$@) {
    my($filename,$name,@diag) = @_;


}



1;

__END__

=encoding utf8
