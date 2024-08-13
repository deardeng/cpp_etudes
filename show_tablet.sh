#!/bin/bash

# MySQL 连接信息
MYSQL_USER="root"
MYSQL_HOST="128.0.1.1"
QUERY_PORT=9030
# MYSQL_DATABASE="your_database"

databases=$(mysql -u$MYSQL_USER -h$MYSQL_HOST -P$QUERY_PORT -e 'SHOW DATABASES;' | awk '{ print $1}' | grep -v -e '__i' -e '^Database$' -e '^information_schema$' -e '^performance_schema$' -e '^mysql$' -e '^sys$')

# 遍历每个数据库
for db in $databases; do
  #echo "Database: $db"
  # 获取所有表的列表
  tables=$(mysql -u$MYSQL_USER -h$MYSQL_HOST -P$QUERY_PORT $db -e 'SHOW TABLES;' | awk '{ print $1}' | grep -v '^Tables')

  # 遍历每个表并打印建表语句
  for table in $tables; do
    create_table_statement=$(mysql -u$MYSQL_USER -h$MYSQL_HOST -P$QUERY_PORT $db -e "SHOW CREATE TABLE $table\G")
    if echo "$create_table_statement" | grep -q 'dynamic_partition'; then
      # echo "Table: $table"
      # echo "$create_table_statement"
      # 获取并处理 show tablets 输出
      show_tablets_output=$(mysql -u$MYSQL_USER -h$MYSQL_HOST -P$QUERY_PORT $db -e "SHOW TABLETS FROM $table\G")
      first_meta_url=$(echo "$show_tablets_output" | grep -oP 'http://[^ ]+/api/meta/header/[0-9]+' | head -n 1)
      if [ -n "$first_meta_url" ]; then
        #echo "Calling URL: $first_meta_url"
				curl_result=$(curl -s "$first_meta_url")
        if echo "$curl_result" | grep -qv 'INTERNAL_ERROR'; then
          echo "db: $db" "table: $table"
          echo "INTERNAL_ERROR found at URL: $first_meta_url"
				fi
      fi
    fi
  done
done
