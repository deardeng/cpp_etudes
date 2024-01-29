#!/usr/bin/perl

use strict;
use warnings;

while(<ARGV>){
    chomp;
    if($_ =~ /tablet scheduler\|53/) {
        print "L: $., C: $_\n"
    }
}
