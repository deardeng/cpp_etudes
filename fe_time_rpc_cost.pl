#!/usr/bin/perl

use strict;
use warnings;

# grep 'create tablets, dbId: 127080\|create tablets response' fe.log|grep -v '00:04:16' > time_rpc_cost.txt
my $filename = $ARGV[0] ;  # 文件名
open(my $fh, "<", $filename) or die "无法打开文件 $filename: $!";
# 2024-01-26 10:17:46,192 INFO (mysql-nio-pool-0|382) [InternalCatalog.createCloudPartitionWithIndices():3773] create tablets, dbId: 127080, tableId: 127088, tableName: income_statistics_service, partitionId: 133691, partitionName: p20240129, indexId: 127089
# 2024-01-26 10:17:46,200 INFO (mysql-nio-pool-0|382) [InternalCatalog.sendCreateTabletsRpc():3797] create tablets response: status {

my $start_timestamp = "";
my $end_timestamp = "";
while (defined(my $startline = <$fh>) and my $endline = <$fh>) {
    chomp($startline);
    chomp($endline);
    if ($startline =~ /(\d{4}-\d{2}-\d{2}) (\d{2}:\d{2}:\d{2},\d{3})/) {
       $startline = $2;
       #print "日期时间字段: $line\n";
    } else {
       print "无法提取start日期时间字段\n";
    }

    if ($endline =~ /(\d{4}-\d{2}-\d{2}) (\d{2}:\d{2}:\d{2},\d{3})/) {
       $endline = $2;
       #print "日期时间字段: $line\n";
    } else {
       print "无法提取end日期时间字段\n";
    }

    my $start_timestamp = $startline;
    my $end_timestamp = $endline;

    if ($start_timestamp ne "" && $end_timestamp ne "") {
        my ($start_hour, $start_min, $start_sec, $start_msec) = split(/[:,]/, $start_timestamp);
        my ($end_hour, $end_min, $end_sec, $end_msec) = split(/[:,]/, $end_timestamp);

        my $start_time = ($start_hour * 3600 * 1000) + ($start_min * 60 * 1000) + ($start_sec * 1000) + $start_msec;
        my $end_time = ($end_hour * 3600 * 1000) + ($end_min * 60 * 1000) + ($end_sec * 1000) + $end_msec;

        my $time_difference = $end_time - $start_time;
        print "时间差: $time_difference 毫秒\n";
    }
}

close($fh);
