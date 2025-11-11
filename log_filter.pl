#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use Time::Piece;
use Data::Dumper;
use Digest::MD5 qw(md5_hex);

# 定义默认配置
my %config = (
    dirs => [],           # 目录列表
    patterns => [],       # 关键词列表
    file_pattern => '.*', # 文件名模式
    max_cascade_depth => 2, # 最大级联深度
    # 级联模式配置，每个模式都可以单独开关
    cascade_config => {
        'table_id' => { enabled => 1, pattern => qr/table_id[=:]\s*(\d+)/i },
        'tablet' => { enabled => 1, pattern => qr/tablet(?:_id|Id)[=:]\s*(\d+)/i },
        'txn_id' => { enabled => 1, pattern => qr/(?:txn|transaction)_id[=:]\s*(\d+)/i },
        'thread_id' => { 
            enabled => 1, 
            pattern => [
                qr/\(([^|)]+?)(?:\||$)/,
                qr/[IW]\d{8}\s+\d{2}:\d{2}:\d{2}\.\d+\s+(\d+)/
            ]
        },
        'load_id' => { enabled => 1, pattern => qr/load_id[=:]\s*([a-fA-F0-9-]+)/i },
        'label' => { enabled => 1, pattern => qr/label[=:]\s*([^\s,]+)/i },
        'query_id' => { enabled => 1, pattern => qr/query_id[=:]\s*([a-fA-F0-9-]+)/i },
        'instance_id' => { enabled => 1, pattern => qr/instance_id[=:]\s*([a-fA-F0-9-]+)/i },
    },
    verbose => 0,
);

# 添加命令行参数解析
GetOptions(
    "d|dirs=s{,}" => \@{$config{dirs}},
    "p|patterns=s{,}" => \@{$config{patterns}},
    "f|file-pattern=s" => \$config{file_pattern},
    "max-depth=i" => \$config{max_cascade_depth},
    "v|verbose" => \$config{verbose},
    "disable=s{,}" => sub { 
        my ($opt, $value) = @_;
        if (exists $config{cascade_config}{$value}) {
            $config{cascade_config}{$value}{enabled} = 0;
        } else {
            warn "Unknown pattern type: $value\n";
        }
    },
    "enable=s{,}" => sub {
        my ($opt, $value) = @_;
        if (exists $config{cascade_config}{$value}) {
            $config{cascade_config}{$value}{enabled} = 1;
        } else {
            warn "Unknown pattern type: $value\n";
        }
    },
    "h|help" => sub { show_help(); exit 0; },
) or die "Error in command line arguments\n";

# 检查必要参数
die "No directories specified. Use -d to specify directories.\n" unless @{$config{dirs}};
die "No patterns specified. Use -p to specify patterns.\n" unless @{$config{patterns}};

# 存储所有匹配结果
my %all_matches;
my %seen_contents;  # 用于去重
my %processed_patterns;  # 用于跟踪已处理过的模式

# 主处理流程
process_patterns($config{patterns}, 0);

# 按时间排序并输出结果
output_sorted_results(\%all_matches);

# 处理搜索模式
sub process_patterns {
    my ($patterns, $depth) = @_;
    
    # 检查深度限制
    if ($depth >= $config{max_cascade_depth}) {
        print "Reached maximum depth $depth, stopping cascade search.\n";
        return;
    }
    
    print "\nProcessing depth $depth...\n";
    my %new_patterns;  # 使用哈希表去重
    
    foreach my $pattern (@$patterns) {
        # 跳过已处理过的模式
        next if $processed_patterns{$pattern};
        
        # 标记该模式已处理
        $processed_patterns{$pattern} = 1;
        
        print "Searching for pattern: $pattern\n";
        my @matches = search_with_rg($pattern);
        my $match_count = scalar(@matches);
        print "Found $match_count matches for pattern: $pattern\n";
        
        foreach my $match (@matches) {
            # 解析并存储匹配行
            process_match($match);
            
            # 收集新的搜索模式
            my @extracted_patterns = extract_cascade_patterns($match);
            foreach my $new_pattern (@extracted_patterns) {
                # 跳过空模式和已处理过的模式
                next unless $new_pattern && length($new_pattern) > 0;
                next if $processed_patterns{$new_pattern};
                
                $new_patterns{$new_pattern} = 1;
            }
        }
    }
    
    # 获取新的未处理模式
    my @next_patterns = keys %new_patterns;
    my $new_pattern_count = scalar(@next_patterns);
    
    if ($new_pattern_count > 0) {
        print "Found $new_pattern_count new patterns at depth $depth\n";
        # 递归处理新模式
        process_patterns(\@next_patterns, $depth + 1);
    } else {
        print "No new patterns found at depth $depth, stopping cascade search.\n";
    }
}

# 使用ripgrep搜索
sub search_with_rg {
    my ($pattern) = @_;
    my %seen_files;
    my @results;

    foreach my $dir (@{$config{dirs}}) {
        # 检查目录是否存在
        unless (-d $dir) {
            warn "Warning: Directory '$dir' does not exist\n";
            next;
        }
        
        # 获取目录中的所有文件，匹配文件模式，并排除符号链接
        opendir(my $dh, $dir) or die "Cannot open directory $dir: $!";
        my @files = map { "$dir/$_" } 
                   grep { 
                       -f "$dir/$_" &&           # 是文件
                       !-l "$dir/$_" &&          # 不是符号链接
                       $_ =~ /$config{file_pattern}/ && 
                       !$seen_files{$dir.$_}++ 
                   } readdir($dh);
        closedir($dh);
        
        my $file_count = scalar(@files);
        print "Searching in $dir ($file_count files)...\n";
        
        # 使用不同的临时文件
        my $temp_file = "temp_$$.txt";
        open(my $out, '>', $temp_file) or die "Cannot open temp file $temp_file: $!";

        foreach my $file (@files) {
            # 使用更高效的ripgrep选项
            my $cmd = qq(rg -n --no-heading --no-line-number -w "$pattern" "$file");
            
            if (open(my $rg, "$cmd 2>/dev/null |")) {
                my $match_count = 0;
                while (my $line = <$rg>) {
                    chomp $line;
                    print $out "$file:1:$line\n";
                    $match_count++;
                }
                close($rg);
                print "Found $match_count matches in file: $file\n" if $match_count > 0;
            }
        }

        close($out);

        # Merge results from temp file
        open(my $in, '<', $temp_file) or die "Cannot open temp file $temp_file: $!";
        push @results, <$in>;
        close($in);
        unlink $temp_file; # Clean up temp file
    }

    return @results;
}

# 提取时间戳
sub extract_timestamp {
    my ($line) = @_;
    
    # 尝试匹配不同的时间戳格式
    my $timestamp;
    if ($line =~ /\d{4}[-\/\.]\d{2}[-\/\.]\d{2}\s+\d{2}:\d{2}:\d{2}(?:\.\d+)?/i) {
        $timestamp = $&;
    } elsif ($line =~ /I(\d{8}\s+\d{2}:\d{2}:\d{2}\.\d+)/i) {
        # 转换 YYYYMMDD 格式为 YYYY-MM-DD
        my $date = substr($1, 0, 8);
        my $time = substr($1, 8);
        $date =~ s/(\d{4})(\d{2})(\d{2})/$1-$2-$3/;
        $timestamp = "$date$time";
    } else {
        # 如果没有找到时间戳，返回一个默认值
        return "9999-99-99 99:99:99.999999";
    }
    
    # 标准化时间戳格式
    $timestamp =~ s/[\/\.]/\-/g;  # 将所有斜杠和点替换为连字符
    
    # 如果没有毫秒部分，添加.000000
    $timestamp .= ".000000" unless $timestamp =~ /\./;
    
    return $timestamp;
}

# 处理匹配结果
sub process_match {
    my ($line) = @_;
    my ($file, $line_num, $content) = split(/:/, $line, 3);
    
    # 提取时间戳
    my $timestamp = extract_timestamp($content);
    
    # 确保时间戳解析正确
    unless ($timestamp) {
        print STDERR "Failed to parse timestamp for line: $line\n";
        $timestamp = "9999-99-99 99:99:99.999999";
    }
    
    # 存储匹配结果
    push @{$all_matches{$timestamp}}, {
        file => $file,
        line_num => $line_num,
        content => $content,
        timestamp => $timestamp
    };
}

# 提取级联搜索模式
sub extract_cascade_patterns {
    my ($line) = @_;
    my @new_patterns;
    my %seen_patterns;
    
    foreach my $type (keys %{$config{cascade_config}}) {
        # 跳过禁用的模式
        next unless $config{cascade_config}{$type}{enabled};
        
        my $patterns = $config{cascade_config}{$type}{pattern};
        $patterns = [$patterns] unless ref($patterns) eq 'ARRAY';
        
        foreach my $pattern (@$patterns) {
            if ($line =~ $pattern) {
                my $value = $1;
                print "Found $type: $value\n" if $config{verbose};
                
                # 根据不同类型处理提取的值
                if ($type eq 'thread_id') {
                    if ($value =~ /^\d+$/ || $value =~ /^([^|]+)/) {
                        my $thread_id = $1 || $value;
                        $thread_id =~ s/^\s+|\s+$//g;
                        unless ($seen_patterns{$thread_id}) {
                            push @new_patterns, $thread_id;
                            $seen_patterns{$thread_id} = 1;
                        }
                    }
                }
                # 处理数字类型的ID
                elsif ($type =~ /^(table_id|tablet|txn_id)$/) {
                    if ($value =~ /^\d+$/) {
                        unless ($seen_patterns{$value}) {
                            push @new_patterns, $value;
                            $seen_patterns{$value} = 1;
                        }
                    }
                }
                # 处理其他类型（包括十六进制ID和label）
                else {
                    unless ($seen_patterns{$value}) {
                        push @new_patterns, $value;
                        $seen_patterns{$value} = 1;
                    }
                }
            }
        }
    }
    
    return @new_patterns;
}

# 输出排序结果
sub output_sorted_results {
    my ($results_ref) = @_;
    
    # Sort results by timestamp using Time::Piece for proper timestamp comparison
    my @sorted;
    foreach my $timestamp (sort keys %$results_ref) {
        push @sorted, @{$results_ref->{$timestamp}};
    }
    
    # Assign different colors to different file names
    my @colors = ("\e[1;31m", "\e[1;32m", "\e[1;34m", "\e[1;35m", "\e[1;36m");
    my $color_index = 0;
    my %file_colors;
    
    # 高亮颜色定义
    my $highlight_color = "\e[1;33m";  # 黄色高亮
    my $reset_color = "\e[0m";
    
    foreach my $result (@sorted) {
        # Assign a color if not already assigned
        if (!exists $file_colors{$result->{file}}) {
            $file_colors{$result->{file}} = $colors[$color_index % @colors];
            $color_index++;
        }
        
        my $colored_file = $file_colors{$result->{file}} . $result->{file} . $reset_color;
        my $content = $result->{content};
        
        # 如果是verbose模式，高亮所有匹配的模式
        if ($config{verbose}) {
            foreach my $type (keys %{$config{cascade_config}}) {
                my $patterns = $config{cascade_config}{$type}{pattern};
                $patterns = [$patterns] unless ref($patterns) eq 'ARRAY';
                
                foreach my $pattern (@$patterns) {
                    # 保存捕获组
                    my @captures;
                    while ($content =~ /$pattern/g) {
                        push @captures, $1 if defined $1;
                    }
                    
                    # 高亮替换
                    foreach my $capture (@captures) {
                        my $escaped_capture = quotemeta($capture);
                        $content =~ s/($escaped_capture)/$highlight_color$1$reset_color/g;
                    }
                }
            }
            
            # 高亮原始搜索模式
            foreach my $pattern (@{$config{patterns}}) {
                my $escaped_pattern = quotemeta($pattern);
                $content =~ s/($escaped_pattern)/$highlight_color$1$reset_color/gi;
            }
        }
        
        #print "[" . $colored_file . "] " . $content . "\n";
        print "[" . $colored_file . "] " . $content;
    }
    
    print "\nTotal matches: " . scalar(@sorted) . "\n";
}

# 显示帮助信息
sub show_help {
    print <<'HELP';
Usage: perl log_filter.pl [options]
Options:
    -d, --dirs         Directories to search in (multiple allowed)
    -p, --patterns     Search patterns (multiple allowed)
    -f, --file-pattern File pattern to match (default: .*)
    --max-depth        Maximum cascade search depth (default: 2)
    --disable          Disable specific pattern types (multiple allowed)
                      Available types: table_id, tablet, txn_id, thread_id, 
                      load_id, label, query_id, instance_id
    --enable           Enable specific pattern types (multiple allowed)
    -v, --verbose      Show detailed matching process
    -h, --help         Show this help message

Example:
    perl log_filter.pl -d 1fe -d 23 -d 30 -p "37275" --disable thread_id --disable label -v
HELP
}
