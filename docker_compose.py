#!/usr/bin/python
# -*-coding:utf-8 -*-
import paramiko
import time
import re
import os
import threading
from colorama import Fore, Style, init
import argparse

# 初始化 colorama
init(autoreset=True)

DEV_HOME = '/mnt/disk2/dengxin/dx_docker'
DEV_MACHINE = '10.16.10.11'
USERNAME = 'dengxin'

# 全局变量
is_cloud_branch = False

def ssh_exec_command_base(command, user_input=None):
    """通过 SSH 连接到远程机器并执行命令"""
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    
    print(f"Attempting to connect to {DEV_MACHINE} as {USERNAME}...")
    try:
        client.connect(DEV_MACHINE, username=USERNAME)
        print(f"Successfully connected to {DEV_MACHINE}.")
    except Exception as e:
        print(f"Failed to connect to {DEV_MACHINE}: {e}")
        return None  # 返回 None 以指示连接失败
    
    try:
        print(f"Executing command: {command}")
        stdin, stdout, stderr = client.exec_command(command)

        # 检查输出中是否需要用户输入
        if user_input is not None:
            input_value = user_input()  # 调用 lambda 函数获取用户输入
            stdin.write(f'{input_value}\n')
            stdin.flush()  # 确保输入被发送

        # 读取输出和错误信息
        output = stdout.read().decode()
        error = stderr.read().decode()

        print(f"{Fore.RED}Error executing command: {error}{Style.RESET_ALL}")
        print(f"{Fore.GREEN}Command output: {output}{Style.RESET_ALL}")

    except Exception as e:
        print(f"An error occurred while executing the command: {e}")
    finally:
        client.close()  # 确保客户端在结束时关闭

    return output

def ssh_exec_command(command):
    """通过 SSH 连接到远程机器并执行命令"""
    return ssh_exec_command_base(command)

def ssh_exec_command_with_y(command):
    """通过 SSH 连接到远程机器并执行命令，要求用户输入"""
    # 定义一个 lambda 函数来获取用户输入
    user_input = lambda: get_user_input(f"{Fore.YELLOW}请输入字符（例如 'y'）以继续: ")

    # 执行命令并传入 lambda 函数
    return ssh_exec_command_base(command, user_input)

def get_my_ip():
    """获取本地机器的 IP 地址"""
    ip = os.popen("ifconfig | grep -w inet | grep 192.168 | grep -v broadcast | cut -d ' ' -f 2").read().strip()
    return ip

def fetch_cloud_fe_config(cloud_conf_file, local_conf_file):
    """从远程机器获取云配置文件"""
    for i in range(60):
        content = ssh_exec_command(f"cat {cloud_conf_file}")
        if "cluster_id" in content:
            with open(local_conf_file, 'a') as f:
                f.write("\n".join(line for line in content.splitlines() if "Connection" not in line))
            print(f"{Fore.BLUE}Save cloud configuration to local fe_custom.conf{Style.RESET_ALL}")
            return
        time.sleep(1)
    print(f"{Fore.RED}No find cloud conf file.{Style.RESET_ALL}")

def setup(branch):
    """设置环境并启动远程集群"""
    global is_cloud_branch  # 声明使用全局变量
    query_ports = {
        "test": 20100,
        "cloud-master": 20200,
        "2.1": 20210,
        "3.0": 20300
    }
    
    query_port = query_ports.get(branch, 20000)

    host = get_my_ip()
    print(f"my ip: {host}")
    
    # 使用 os.getenv 获取 HOME 环境变量
    home_dir = os.getenv("HOME")
    fe_dir = os.path.expanduser(f"{home_dir}/workspace/doris-run/{branch}/fe")
    conf = os.path.join(fe_dir, "conf", "fe_custom.conf")
    
    os.system(f"rm -rf {fe_dir}/doris-meta")
    os.system(f"mkdir {fe_dir}/doris-meta")
    os.system(f"rm -rf {conf}")

    cloud_option = ""
    if is_cloud_branch:  # 使用全局变量
        cloud_option = "--cloud"
        with open(conf, 'a') as f:
            f.write("http_port = 8031\n")
            f.write("rpc_port = 9021\n")
            f.write("query_port = 9031\n")
            f.write("edit_log_port = 9011\n")
    
    with open(conf, 'a') as f:
        f.write("sys_log_verbose_modules = org\n")
        f.write("enable_print_request_before_execution = true\n")
        f.write(f"priority_networks = {host}\n")
        f.write(f"query_port = {query_port}\n")

    command = f"up dengxin-{branch} dengxin:{branch} --be-config \"sys_log_verbose_modules = *\" --add-be-num 4 --remote-master-fe {host}:{query_port} --local-network-ip 10.16.10.11 {cloud_option}"
    full_command = f"export LOCAL_DORIS_PATH={DEV_HOME}; python /mnt/disk2/dengxin/apache_doris/docker/runtime/doris-compose/doris-compose.py {command}"
    
    if is_cloud_branch:
        ssh_exec_command_with_y(full_command)
    else:
        ssh_exec_command(full_command)

def get_user_input(prompt):
    """获取用户输入并返回"""
    return input(prompt)

def main():
    global is_cloud_branch  # 声明使用全局变量
    parser = argparse.ArgumentParser(description="Setup and manage the remote cluster.")
    parser.add_argument('--branch', type=str, default='cloud-master', help='Branch name to use')
    args = parser.parse_args()

    branch_name = args.branch  # 使用传入的参数
    is_cloud_branch = branch_name.startswith("cloud")  # 设置全局变量

    cloud_conf_file = f"{DEV_HOME}/dengxin-{branch_name}/status/remote_master_fe_add.conf"
    local_conf_file = f"{os.path.expanduser('~')}/workspace/doris-run/{branch_name}/fe/conf/fe_custom.conf"

    print(f"Using branch: {branch_name}")
    print("down remote cluster...")
    command = f"down --clean dengxin-{branch_name}"
    full_command = f"export LOCAL_DORIS_PATH={DEV_HOME}; python /mnt/disk2/dengxin/apache_doris/docker/runtime/doris-compose/doris-compose.py {command}"
    ssh_exec_command(full_command) 

    # 创建线程
    setup_thread = threading.Thread(target=setup, args=(branch_name,))
    if is_cloud_branch:  # 使用全局变量
        fetch_thread = threading.Thread(target=fetch_cloud_fe_config, args=(cloud_conf_file, local_conf_file))
    
    # 启动线程
    setup_thread.start()
    if is_cloud_branch:  # 使用全局变量
        fetch_thread.start()
    
    # 等待线程完成
    setup_thread.join()
    if is_cloud_branch:  # 使用全局变量
        fetch_thread.join()

if __name__ == "__main__":
    main()
