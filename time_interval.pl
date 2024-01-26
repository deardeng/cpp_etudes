#!/usr/bin/perl

use strict;
use warnings;

# grep 'create tablets' fe.log |grep 'income_statistics_service' > time_interval.txt
my $filename = $ARGV[0] ;  # 文件名
open(my $fh, "<", $filename) or die "无法打开文件 $filename: $!";

my $previous_timestamp = "";
while (my $line = <$fh>) {
    chomp($line);
    # 2024-01-26 10:17:46,018 INFO (mysql-nio-pool-0|382) [InternalCatalog.createCloudPartitionWithIndices():3773] create tablets, dbId: 127080, tableId: 127088, tableName: income_statistics_service, partitionId: 133619, partitionName: p20240121, indexId: 127089
    if ($line =~ /(\d{4}-\d{2}-\d{2}) (\d{2}:\d{2}:\d{2},\d{3})/) {
       $line = $2;
       #print "日期时间字段: $line\n";
    } else {
       print "无法提取日期时间字段\n";
    }
    my $current_timestamp = $line;

    if ($previous_timestamp ne "") {
        my ($prev_hour, $prev_min, $prev_sec, $prev_msec) = split(/[:,]/, $previous_timestamp);
        my ($curr_hour, $curr_min, $curr_sec, $curr_msec) = split(/[:,]/, $current_timestamp);

        my $prev_time = ($prev_hour * 3600 * 1000) + ($prev_min * 60 * 1000) + ($prev_sec * 1000) + $prev_msec;
        my $curr_time = ($curr_hour * 3600 * 1000) + ($curr_min * 60 * 1000) + ($curr_sec * 1000) + $curr_msec;

        my $time_difference = $curr_time - $prev_time;
        print "时间差: $time_difference 毫秒\n";
    }

    $previous_timestamp = $current_timestamp;
}

close($fh);
