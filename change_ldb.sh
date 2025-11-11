# ...existing code...
#!/usr/bin/env bash
set -euo pipefail

BASE="/mnt/disk2/dengxin/tools"
CUR="$BASE/ldb"
V20="$BASE/ldb.20"
V18="$BASE/ldb.18"

err(){ echo "$1" >&2; exit 1; }
ts(){ date +%s; }

# 优先切换 ldb.20 -> ldb
if [ -e "$V20" ]; then
  [ -e "$V18" ] && mv -f "$V18" "${V18}.bak.$(ts)"
  [ -e "$CUR" ] && mv -f "$CUR" "$V18"
  mv -f "$V20" "$CUR"
  echo "Switched: ldb <- ldb.20 (old ldb -> ldb.18)"
  clang -v 2>&1 || true
  exit 0
fi

# 否则切换 ldb.18 -> ldb
if [ -e "$V18" ]; then
  [ -e "$V20" ] && mv -f "$V20" "${V20}.bak.$(ts)"
  [ -e "$CUR" ] && mv -f "$CUR" "$V20"
  mv -f "$V18" "$CUR"
  echo "Switched: ldb <- ldb.18 (old ldb -> ldb.20)"
  clang -v 2>&1 || true
  exit 0
fi

err "No ldb.20 or ldb.18 found in $BASE"
# ...existing code...