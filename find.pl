#!/usr/bin/perl

# find . -name "*.java" -exec perl find.pl {}  \;

use strict;
use warnings;

my $previous_line = ''; # 上一行
my $current_line = '';  # 当前行

while (<>) {
    chomp $_;

    # 如果上一行带有"SerializedName"，并且当前行带有"Map"
    if ($previous_line =~ /SerializedName/ && $_=~ /Map/) {
        print "上一行: $previous_line\n";
        print "当前行: $_\n";
        print "\n";
    }

    $previous_line = $_;
}
