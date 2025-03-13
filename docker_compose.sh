#/bin/bash
DEV_HOME=/mnt/disk2/dengxin/dx_docker
DEV_MACHINE=10.16.10.11

function rdc {
    ssh -t dengxin@${DEV_MACHINE} "export LOCAL_DORIS_PATH=$DEV_HOME; python /mnt/disk2/dengxin/apache_doris/docker/runtime/doris-compose/doris-compose.py $@"
}

function get_my_ip {
    ifconfig | grep -w inet | grep 192.168 | grep -v broadcast | cut -d ' ' -f 2
}

#stty -tostop
#cloud_conf_file="$DEV_HOME/dengxin-${branch}/status/remote_master_fe_add.conf"
#local_conf_file="$HOME/workspace/doris-run/${branch}/fe/conf/fe_custom.conf"
cloud_conf_file="$DEV_HOME/dengxin-cloud-master/status/remote_master_fe_add.conf"
local_conf_file="$HOME/workspace/doris-run/cloud-master/fe/conf/fe_custom.conf"
#fetch_cloud_fe_config $cloud_conf_file $conf &

function fetch_cloud_fe_config() {
    # cloud_conf_file=$1
    # local_conf_file=$2
    RED='\033[0;31m'
    NC='\033[0m'
    for i in $(seq 1 60); do
        content=`ssh dengxin@${DEV_MACHINE} "cat $cloud_conf_file"`
        if [[ ${content} =~ "cluster_id" ]]; then
            echo "${content}" | grep -v "Connection" >> $local_conf_file
            echo "${RED} Save cloud configuration to local fe_custom.conf ${NC}"
            return
        fi
        sleep 1
    done
    echo "${RED} No find cloud conf file. ${NC}"
}

function setup {
    branch=$1
    case "$branch" in
    "test")
        query_port=20100
        ;;
    "cloud-master")
        query_port=20200
        ;;
    "2.1")
        query_port=20210
        ;;
    "3.0")
        query_port=20300
        ;;
    *)
        branch="main"
        query_port=20000
        ;;
    esac

    echo "down remote cluster..."
    rdc "down --clean dengxin-${branch}"     
            host=`get_my_ip`
    echo "my ip:  ${host}"
    fe_dir="$HOME/workspace/doris-run/${branch}/fe"
    conf="${fe_dir}/conf/fe_custom.conf"
    rm -rf "${fe_dir}/doris-meta"
    mkdir "${fe_dir}/doris-meta"
    rm -rf $conf

    # Add --cloud option if branch starts with "cloud"
    cloud_option=""
    if [[ "$branch" == cloud* ]]; then
        cloud_option="--cloud"
        echo "http_port = 8031" >>$conf
        echo "rpc_port = 9021" >>$conf
        echo "query_port = 9031" >>$conf
        echo "edit_log_port = 9011" >>$conf
    fi
    echo "sys_log_verbose_modules = org" >>$conf
    echo "enable_print_request_before_execution = true" >>$conf
    echo "priority_networks = ${host}" >>$conf
    echo "query_port = ${query_port}" >>$conf



    rdc "up dengxin-${branch} dengxin:${branch} --be-config \"sys_log_verbose_modules = \*\" --add-be-num 4 --remote-master-fe ${host}:${query_port} --local-network-ip 10.16.10.11 $cloud_option"
}
