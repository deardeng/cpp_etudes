#!/usr/bin/perl

my $fe_master_ip = "127.0.0.1";
my $fe_query_port=39430;
my $fe_user="root";
my $fe_passwd='\0';
my $be_ip = "127.0.0.1";

open my $fh, "<", "./${be_ip}.txt" or die "open file failed: $!";
my @lines = <$fh>;

for my $tablet_id (@lines) {
    chomp $tablet_id;
    my $query = "show tablet ${tablet_id}";
    my @result = qx(mysql -h${fe_master_ip} -u${fe_user} -p${fe_passwd} -P${fe_query_port} -e "$query");

    @ret = split /\s+/, $result[1];

    $query = "show proc $ret[-1]";

    @result = qx(mysql -h${fe_master_ip} -u${fe_user} -p${fe_passwd} -P${fe_query_port} -e "$query");

    for my $item (@result) {
        if ($item =~ /${be_ip}/) {
            my $need_fix_beid = (split /\s+/, $item)[1];
            print "fix be: $need_fix_beid\n";
            $query = "ADMIN SET REPLICA STATUS PROPERTIES('tablet_id' = '${tablet_id}', 'backend_id' = '${need_fix_beid}', 'status' = 'bad')";
            print $query ."\n";
            qx(mysql -h${fe_master_ip} -u${fe_user} -p${fe_passwd} -P${fe_query_port} -e "$query");
            last;
        }
    }
}


