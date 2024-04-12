#!/usr/bin/perl
use strict;
use warnings;
use v5.10;
use Cwd qw/abs_path/;

sub get_path_of_script() {
    if ($0 !~ qr'/') {
        my ($path) = map {chomp;
        $_} qx(which $0 2>/dev/null);
        return $path;
    }
    else {
        return abs_path($0);
    }
}

sub script_basename() {
    get_path_of_script() =~ m{/([^/]+?)(?:\.\w+)?$};
    $1
}

sub script_dir() {
    get_path_of_script() =~  m{^(.*/)};
    $1
}

my $script_basename = script_dir();
qx(git restore $script_basename);

sub change_file ($$){
    my ($filename, $change) = @_;
    my $file = $script_basename . $filename;
    open(my $filehandle, '<', $file) or die "read $filename failed: $!";
    my @lines = <$filehandle>;
    close($filehandle);

    $change->(\@lines);

    open($filehandle, '>', $file) or die "write $filename failed: $!";
    print $filehandle @lines;
    close($filehandle);
}

my $change_dockerfile = sub(@) {
    my ($lines) = @_;
    # fuck docker 内使用 perf 也无效
    # https://chinggg.github.io/post/docker-perf/
    # 开启sys admin 和 privileged 后，正常使用了
    my $add_tools = "gdb linux-perf";
    foreach my $line (@$lines) {
        $line =~ s/&&/$add_tools &&/ if $line =~ qr(apt-get install -y);
    }
    # fuck docker 内修改 core_pattern 不生效
    # echo "kernel.core_pattern = /tmp/core.%e.%p.%t">/etc/sysctl.conf
    # sysctl -p
    # push @$lines, "\nRUN echo \"kernel.core_pattern = /opt/apache-doris/core_dump/core.%e.%p.%t\">/etc/sysctl.conf";
    # push @$lines, "\nRUN sysctl -p\n";
    push @$lines, "\nRUN rm -fr /usr/bin/perf; ln -s /usr/bin/perf_5.10 /usr/bin/perf\n"
};

change_file("Dockerfile", $change_dockerfile);

my $change_cluster_file = sub {
    my ($lines) = @_;
    my $fe_debug_port = 8899;
    foreach my $line (@$lines) {
        if ($line =~ qr(volumes = \[)) {
            $line = $line."            \"{}:{}/{}\".format(os.path.join(self.get_path(),
                            \"core_dump\"), DOCKER_DORIS_PATH, \"core_dump\")\n        \] + \[\n"
        }
        $line =~ s#"cap_add": \["SYS_PTRACE"\],#\"cap_add\": \["SYS_ADMIN"\],
            "privileged": "true",#;

        $line =~ s#(envs\["JACOCO_COVERAGE_OPT"\] = )(.*)\R*#$1"-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:$fe_debug_port"#m;
        $line =~ s#^.*=excludes=org.apache.*\R*##;
        $line =~ s#^.*:com.aliyun.*\R*##;
        $line =~ s#"output=file.*$##;

        $line =~ s#(return \[FE_HTTP_PORT, FE_EDITLOG_PORT, FE_RPC_PORT, FE_QUERY_PORT)\]#$1, $fe_debug_port\]#
    }
};

change_file("cluster.py", $change_cluster_file);

my $change_common_file = sub {
    my ($lines) = @_;
    my $tab = ' ' x 4;
    my $str = "health_log \"set core path\" `sysctl -w kernel.core_pattern=/opt/apache-doris/core_dump/core.%e.%p.%t`";
    foreach my $line (@$lines) {
        $line =~ s/(SIGTERM)/$1\n$tab$str/
    }
};

change_file("resource/init_be.sh", $change_common_file);
change_file("resource/init_cloud.sh", $change_common_file);

