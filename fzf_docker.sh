#!/usr/bin/env bash
set -euo pipefail

# 从 fzf 选择一行，提取 IP 和 PORT，然后用 mycli 连接
selection=$(python /mnt/disk2/dengxin/apache_doris/docker/runtime/doris-compose/doris-compose.py ls --detail -v \
  | grep -w ' dengxin ' | fzf) || exit 1

if [ -z "${selection:-}" ]; then
  echo "No selection" >&2
  exit 1
fi

ipport=$(awk '{print $8}' <<<"$selection")
IP=${ipport%%:*}
PORT=${ipport#*:}

if [ -z "${IP:-}" ]; then
  echo "No IP found" >&2
  exit 1
fi

if [ "$PORT" = "$ipport" ] || [ -z "${PORT:-}" ]; then
  PORT=3306
fi

exec mycli -uroot -h "$IP" -P "$PORT"