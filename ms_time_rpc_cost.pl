#!/usr/bin/perl

use strict;
use warnings;

my $filename = $ARGV[0] ;  # 文件名
open(my $fh, "<", $filename) or die "无法打开文件 $filename: $!";

# I0123 13:22:06.980171 2525996 meta_service_helper.h:27] begin create_tablets from 127.0.0.1:60418
# I0123 13:22:06.984261 2526011 meta_service_helper.h:80] finish create_tablets from 127.0.0.1:60418 response=status { code: OK msg: "" }

my $start_timestamp = "";
my $end_timestamp = "";
while (defined(my $startline = <$fh>) and my $endline = <$fh>) {
    chomp($startline);
    chomp($endline);
    if ($startline =~ /(I\d{4}) (\d{2}:\d{2}:\d{2}.\d{6})/) {
       $startline = $2;
       #print "日期时间字段: $line\n";
    } else {
       print "无法提取start日期时间字段\n";
    }

    if ($endline =~ /(I\d{4}) (\d{2}:\d{2}:\d{2}.\d{6})/) {
       $endline = $2;
       #print "日期时间字段: $line\n";
    } else {
       print "无法提取end日期时间字段\n";
    }

    my $start_timestamp = $startline;
    my $end_timestamp = $endline;

    if ($start_timestamp ne "" && $end_timestamp ne "") {
        my ($start_hour, $start_min, $start_sec, $start_msec) = split(/[:.]/, $start_timestamp);
        my ($end_hour, $end_min, $end_sec, $end_msec) = split(/[:.]/, $end_timestamp);

        my $start_time = ($start_hour * 3600 * 1000) + ($start_min * 60 * 1000) + ($start_sec * 1000) + $start_msec;
        my $end_time = ($end_hour * 3600 * 1000) + ($end_min * 60 * 1000) + ($end_sec * 1000) + $end_msec;

        my $time_difference = ($end_time - $start_time) / 1000.0;
        print "时间差: $time_difference 毫秒\n";
    }
}

close($fh);
