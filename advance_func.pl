#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use Storable qw(retrieve nstore);

# perl -MStorable -MData::Dumper -e '$data = retrieve("cache_file.dat"); print Dumper($data);'

sub get_cached_or_run(&$$;@) {
    print "2222 @_\n";
    # 这里的args 为空，因为38调用处没有传参
    my ($func, $validate_func, $cached_file, @args) = @_;

    if (-e $cached_file && -r $cached_file) {
        my $result = retrieve($cached_file);
        if (defined($result) && ref($result) eq ref([]) && $validate_func->(@$result)) {
            return @$result;
        }
    }

    print "6666 @args\n";
    my @result = $func->(@args);
    nstore [ @result ], $cached_file;
    return @result;
}

sub get_cache_or_run_keyed($$$;@) {
    my ($key, $file, $func, @args) = @_;

    die "Invalid data" unless defined($key) && ref($key) eq 'ARRAY';
    die "Invalid func" unless defined($func);

    my $expect_key = join "\0", @$key;

    my $check_key = sub(\%) {
        my $data = shift;
        print "5555 $expect_key\n";
        return exists $data->{cached_key} && $data->{cached_key} eq $expect_key;
    };

    my @result = get_cached_or_run {{
            cached_key => $expect_key,
            cached_data => [ $func->(@args) ]
    }} $check_key, $file;

    return @{$result[0]->{cached_data}};
}

# Example usage
my @key = ('cache_key');
my $file = 'cache_file.dat';

my $func = sub {
    my ($arg1, $arg2) = @_;
    # Code block to be executed
    return $arg1 + $arg2;
};

my @args = (2, 3);
my @result = get_cache_or_run_keyed(\@key, $file, $func, @args);

print "@result\n";  # Output: 5
