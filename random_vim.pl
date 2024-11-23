#!/usr/bin/perl
use strict;
use warnings;
use Time::Local;

# 读取文件内容
my $filename = '/Users/dengxin/CLionProjects/cpp_etudes/vim实用技巧学习笔记.vim';  # 替换为您的文件名
#my $filename = '/Users/dengxin/vim实用技巧学习笔记.vim';  # 替换为您的文件名
open my $fh, '<', $filename or die "Could not open file: $!";

# 读取整个文件内容
local $/;  # 将输入记录分隔符设置为 undef，允许读取整个文件
my $content = <$fh>;
close $fh;

# 使用正则表达式提取段落
my @paragraphs = $content =~ /############(.*?)############/sg;

# 去掉段落两边的空白字符
#@paragraphs = map { s/^\s+|\s+$//gr } @paragraphs;

# 打印每个段落，并在每个段落后添加一个空行
#foreach my $paragraph (@paragraphs) {
#        print '---';
#        print "$paragraph";  # 输出段落和空行
#        print '---';
#}

# 创建 5 个子数组
my @subarrays;
for my $i (0..4) {
        push @subarrays, [];
}

# 将段落分配到子数组
for my $i (0 .. $#paragraphs) {
        push @{$subarrays[$i % 5]}, $paragraphs[$i];
}

# 获取当前周的第几天 (1 = 周一, 7 = 周日)
my @time = localtime();
my $origin_day_of_week = $time[6]; 
my $day_of_week = $origin_day_of_week % 5;

# 获取对应的子数组
my $selected_subarray = $subarrays[$day_of_week - 1];  # 数组索引从 0 开始


#foreach my $paragraph (@$selected_subarray) {
#        print '---';
#        print "$paragraph";  # 输出段落和空行
#        print '---';
#}

# 随机选择并打印内容
if (@$selected_subarray) {
        my $random_index = int(rand(@$selected_subarray));  # 随机索引
        print "today is day of week {$origin_day_of_week}, learning the {$random_index} item and need learn {".@$selected_subarray."} items\n";
        print "$selected_subarray->[$random_index]\n";
} else {
        print "No content available for today.\n";
}

## 随机选择一个段落
#if (@paragraphs) {
#        #    print @paragraphs;
#        my $random_paragraph = $paragraphs[int(rand(@paragraphs))];
#        print "$random_paragraph\n";
#} else {
#        print "No paragraphs found.\n";
#}
