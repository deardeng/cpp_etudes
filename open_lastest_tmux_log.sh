#!/usr/bin/env bash
set -euo pipefail

DIR="/mnt/disk2/dengxin/tmux_history"

if [ ! -d "$DIR" ]; then
  echo "Directory not found: $DIR" >&2
  exit 1
fi

# 找到按修改时间最新的普通文件
file=$(find "$DIR" -maxdepth 1 -type f -printf "%T@ %p\n" 2>/dev/null | sort -n | tail -n1 | awk '{$1=""; sub(/^ /,""); print}')

if [ -z "$file" ]; then
  echo "No files found in $DIR" >&2
  exit 1
fi

# 使用 nvim 打开
exec nvim "$file"