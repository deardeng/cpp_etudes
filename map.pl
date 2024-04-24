#!/usr/bin/perl
use strict;
use warnings;
use v5.10;

# 示例数据
my $node = {
    callees => [
        { name => 'John', age => 25 },
        { name => 'Alice', age => 30 }
    ]
};

# 创建 $callees1 数组引用
my $callees1 = [ map { +{ %{$_} } } @{$node->{callees}} ];

# 输出 $callees1 数组引用的内容
foreach my $callee (@$callees1) {
    print "Name: $callee->{name}, Age: $callee->{age}\n";
}


my @callees2=  map +{%{$_}}, @{$node->{callees}} ;

foreach my $c (@callees2) {
    print "Name: $c->{name}, Age: $c->{age}\n";
}