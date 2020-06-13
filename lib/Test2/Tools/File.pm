package Test2::Tools::File;

# ABSTRACT: Exports test functions for files and directories

use strict;
use warnings;

use File::Spec;
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
    $filename = _normalize($filename);
    $name //= "$filename exists";

    my $ctx = context();

    @diag = ("File [$filename] does not exist") unless @diag;

    return $ctx->pass_and_release($name) if -e $filename;
    return $ctx->fail_and_release($name,@diag);

}

sub file_not_exists_ok($;$@) {

    my($filename,$name,@diag) = @_;
    $filename = _normalize($filename);
    $name //= "$filename doesn't exist";

    my $ctx = context();

    @diag = ("File [$filename] exists") unless @diag;

    return $ctx->pass_and_release($name) if not -e $filename;
    return $ctx->fail_and_release($name,@diag);

}

sub file_empty_ok($;$@) {

    my($filename,$name,@diag) = @_;
    $filename = _normalize($filename);
    $name //= "$filename is empty";

    my $ctx = context();

    @diag = ("File [$filename] exists with non-zero size!") unless @diag;

    if (not -e $filename) {
        return $ctx->fail_and_release( $name, "File [$filename] does not exist!" );
    }

    return $ctx->pass_and_release($name) if -z $filename;
    return $ctx->fail_and_release($name,@diag);

}

sub file_not_empty_ok($;$@) {
    my($filename,$name,@diag) = @_;
    $filename = _normalize($filename);
    $name //= "$filename is not empty";

    @diag = ("File [$filename] exists with zero size!") unless @diag;

    my $ctx = context();

    if (not -e $filename) {
        return $ctx->fail_and_release($name,"File [$filename] does not exist!");
    }

    return $ctx->pass_and_release($name) if not -z $filename;
    return $ctx->fail_and_release($name,@diag);

}

sub file_size_ok($$;$@) {
    my($filename,$expected,$name,@diag) = @_;
    $filename = _normalize($filename);
    $expected = int $expected;
    $name //= "$filename has right size";

    my $ctx = context();

    if (not -e $filename) {
        return $ctx->fail_and_release($name,"File [$filename] does not exist");
    }

    my $actual = -s $filename;
    @diag = ("File [$filename] has actual size [$actual] not [$expected]!") unless @diag;

    return $ctx->pass_and_release($name) if $actual == $expected;
    return $ctx->fail_and_release($name,@diag);

}

sub file_max_size_ok($;$@) {
    my($filename,$max,$name,@diag) = @_;
    $filename = _normalize($filename);
    $max = int $max;
    $name //= "$filename is under $max bytes";

    my $ctx = context();

    if (not -e $filename) {
        return $ctx->fail_and_release($name,"File [$filename] does not exist");
    }

    my $actual = -s $filename;
    @diag = ("File [$filename] has actual size [$actual] greater than [$max]!" ) unless @diag;

    return $ctx->pass_and_release($name) if $actual <= $max;
    return $ctx->fail_and_release($name,@diag);

}

sub file_min_size_ok($;$@) {
    my($filename,$min,$name,@diag) = @_;
    $filename = _normalize($filename);
    $min = int $min;
    $name //= "$filename is over $min bytes";

    my $ctx = context();

    if (not -e $filename) {
        return $ctx->fail_and_release($name,"File [$filename] does not exist");
    }

    my $actual = -s $filename;
    @diag = ("File [$filename] has actual size [$actual] less than [$min]!" ) unless @diag;

    return $ctx->pass_and_release($name) if $actual >= $min;
    return $ctx->fail_and_release($name,@diag);

}

sub file_readable_ok($;$@) {
    my($filename,$name,@diag) = @_;
    $filename = _normalize($filename);
    $name //= "$filename is readable";

    my $ctx = context();

    @diag = ("File [$filename] is not readable!") unless @diag;

    return $ctx->pass_and_release($name) if -r $filename;
    return $ctx->fail_and_release($name,@diag);

}

sub file_not_readable_ok($;$@) {
    my($filename,$name,@diag) = @_;
    $filename = _normalize($filename);
    $name //= "$filename is not readable";

    my $ctx = context();

    @diag = ("File [$filename] is readable!") unless @diag;

    return $ctx->pass_and_release($name) if not -r $filename;
    return $ctx->fail_and_release($name,@diag);

}

sub file_writeable_ok($;$@) {
    my($filename,$name,@diag) = @_;
    $filename = _normalize($filename);
    $name //= "$filename is writeable";

    my $ctx = context();

    @diag = ("File [$filename] is not writeable!") unless @diag;

    return $ctx->pass_and_release($name) if -w $filename;
    return $ctx->fail_and_release($name,@diag);

}

sub file_not_writeable_ok($;$@) {
    my($filename,$name,@diag) = @_;
    $filename = _normalize($filename);
    $name //= "$filename is not writeable";

    my $ctx = context();

    @diag = ("File [$filename] is writeable!") unless @diag;

    return $ctx->pass_and_release($name) if not -w $filename;
    return $ctx->fail_and_release($name,@diag);

}

sub file_executable_ok($;$@) {
    my($filename,$name,@diag) = @_;
    $filename = _normalize($filename);
    $name //= "$filename is executable";

    my $ctx = context();

    if ( _win32() ) {
        $ctx->skip( $name, "file_executable_ok doesn't work on Windows!" );
        return $ctx->release;
    }

    @diag = ("File [$filename] is not executable!") unless @diag;

    return $ctx->pass_and_release($name) if -x $filename;
    return $ctx->fail_and_release($name,@diag);

}

sub file_not_executable_ok($;$@) {
    my($filename,$name,@diag) = @_;
    $filename = _normalize($filename);
    $name //= "$filename is not executable";

    my $ctx = context();

    if ( _win32() ) {
        $ctx->skip( $name, "file_not_executable_ok doesn't work on Windows!" );
        return $ctx->release;
    }

    @diag = ("File [$filename] is executable!") unless @diag;

    return $ctx->pass_and_release($name) if not -x $filename;
    return $ctx->fail_and_release($name,@diag);

}

sub file_mode_is($;$@) {
    my($filename,$mode,$name,@diag) = @_;
    $filename = _normalize($filename);
    $name //= sprintf("%s mode is %04o", $filename, $mode);

    my $ctx = context();

    if ( _win32() ) {
        $ctx->skip( $name, "file_mode_is doesn't work on Windows!" );
        return $ctx->release;
    }

    my $ok = -e $filename && ((stat($filename))[2] & 07777) == $mode;

    @diag = (sprintf("File [%s] mode is not %04o!", $filename, $mode)) unless @diag;

    return $ctx->pass_and_release($name) if $ok;
    return $ctx->fail_and_release($name,@diag);

}

sub file_mode_isnt($;$@) {
    my($filename,$mode,$name,@diag) = @_;
    $filename = _normalize($filename);
    $name //= sprintf("%s mode is not %04o", $filename, $mode);

    my $ctx = context();

    if ( _win32() ) {
        $ctx->skip( $name, "file_mode_isnt doesn't work on Windows!" );
        return $ctx->release;
    }

    my $ok = not (-e $filename && ((stat($filename))[2] & 07777) == $mode);

    @diag = (sprintf("File [%s] mode is %04o!", $filename, $mode)) unless @diag;

    return $ctx->pass_and_release($name) if $ok;
    return $ctx->fail_and_release($name,@diag);

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

## INTERNAL UTILS ##

# These are shamelessly copied from brian d foy's Test::File.

sub _normalize {
    my $file = shift;
    return unless defined $file;

    return $file =~ m|/|
        ? File::Spec->catfile( split m|/|, $file )
        : $file;

}

sub _win32 {
    return 0 if $^O eq 'darwin';
    return $ENV{PRETEND_TO_BE_WIN32} if defined $ENV{PRETEND_TO_BE_WIN32};
    return $^O =~ m/Win/;
}

# returns true if symlinks can't exist
sub _no_symlinks_here { ! eval { symlink("",""); 1 } }

# owner_is and owner_isn't should skip on OS where the question makes no
# sense.  I really don't know a good way to test for that, so I'm going
# to skip on the two OS's that I KNOW aren't multi-user.  I'd love to add
# more if anyone knows of any
#   Note:  I don't have a dos or mac os < 10 machine to test this on
sub _obviously_non_multi_user {

    foreach my $os ( qw(dos MacOS) ) {
        return 1 if $^O eq $os;
    }

    return 0 if $^O eq 'MSWin32';

    eval { my $holder = getpwuid(0) };
    return 1 if $@;

    eval { my $holder = getgrgid(0) };
    return 1 if $@;

    return 0;
}

sub _ENOFILE   () { -1 }
sub _ECANTOPEN () { -2 }

sub _file_line_counter {

    my $filename = shift;

    return _ENOFILE   unless -e $filename; # does not exist

    return _ECANTOPEN unless open my( $fh ), "<", $filename;

    my $count = 0;
    while ( <$fh> ) {
        $count++;
    }

    return $count;
}

1;

__END__

=encoding utf8
