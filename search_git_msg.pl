#!/usr/bin/perl
use strict;
use warnings;

# 检查输入参数
my $search_msg = shift @ARGV or die "Usage: $0 <search_message>\n";

# 使用 git log 查找包含搜索消息的提交
my @commits = `git log --all --grep=\Q$search_msg\E --pretty=format:"%H"`;

# 如果没有找到包含消息的提交
if (!@commits) {
    print "No commits found containing the message '$search_msg'.\n";
    exit;
}

# 输出找到的提交哈希
print "Commits containing the message '$search_msg':\n";
print "$_\n" for @commits;

# 查找包含这些提交的标签
print "\nTags containing the message '$search_msg':\n";
foreach my $commit_hash (@commits) {
    chomp($commit_hash);
    my @tags = `git tag --contains $commit_hash`;
    print "$_\n" for @tags;
}

# 查找包含这些提交的分支
print "\nBranches containing the message '$search_msg':\n";
foreach my $commit_hash (@commits) {
    chomp($commit_hash);
    my @branches = `git branch --contains $commit_hash`;
    print "$_\n" for @branches;
}
