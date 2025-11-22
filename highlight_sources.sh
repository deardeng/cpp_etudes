#!/usr/bin/env bash

set -euo pipefail

# 显示使用说明
show_usage() {
  cat << EOF
Usage: $0 [WORKSPACE_DIR]

Convert code files (*.sh, *.template, *.md, etc.) in the workspace to HTML files.

Arguments:
  WORKSPACE_DIR    Directory to process (default: current directory)

Options:
  -h, --help       Show this help message

Examples:
  $0                                    # Process current directory
  $0 /path/to/project                   # Process specified directory
  $0 /mnt/disk2/dengxin/cloud_sim.html  # Process cloud_sim.html directory

EOF
}

# 解析参数
if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  show_usage
  exit 0
fi

# 获取工作目录：如果提供了参数则使用参数，否则使用当前目录
if [ $# -gt 0 ]; then
  WORKSPACE_DIR="$1"
else
  WORKSPACE_DIR="$(pwd)"
fi

# 转换为绝对路径并验证目录是否存在
if [ ! -d "${WORKSPACE_DIR}" ]; then
  echo "Error: Directory '${WORKSPACE_DIR}' does not exist." >&2
  exit 1
fi

WORKSPACE_DIR="$(cd "${WORKSPACE_DIR}" && pwd)"
OUTPUT_ROOT="${WORKSPACE_DIR}_html"
SUPPORTED_PATTERNS=("*.py" "*.java" "*.groovy" "*.sh" "*.template" "*.md")

# 定义扩展名到语法类型的映射
declare -A SYNTAX_MAP=(
  ["sh"]="sh"
  ["bash"]="sh"
  ["template"]="sh"
  ["md"]="markdown"
  ["java"]="java"
  ["cpp"]="cpp"
  ["cc"]="cpp"
  ["cxx"]="cpp"
  ["c"]="c"
  ["h"]="c"
  ["hpp"]="cpp"
  ["py"]="python"
  ["js"]="javascript"
  ["ts"]="typescript"
  ["json"]="json"
  ["xml"]="xml"
  ["html"]="html"
  ["css"]="css"
  ["sql"]="sql"
  ["go"]="go"
  ["rs"]="rust"
  ["rb"]="ruby"
  ["php"]="php"
  ["pl"]="perl"
  ["yaml"]="yaml"
  ["yml"]="yaml"
  ["ini"]="ini"
  ["conf"]="ini"
)

# 根据文件扩展名获取语法类型
get_syntax_by_extension() {
  local file="$1"
  local ext="${file##*.}"
  ext="${ext,,}"  # 转换为小写
  
  # 如果是 template 文件，尝试从文件名中提取真正的扩展名
  if [ "${ext}" = "template" ]; then
    local base="${file%.template}"
    local nested_ext="${base##*.}"
    if [ -n "${nested_ext}" ] && [ "${nested_ext}" != "${base}" ]; then
      nested_ext="${nested_ext,,}"
      if [ -n "${SYNTAX_MAP[$nested_ext]:-}" ]; then
        echo "${SYNTAX_MAP[$nested_ext]}"
        return
      fi
    fi
  fi
  
  # 返回映射的语法类型，如果不存在则默认使用 sh
  echo "${SYNTAX_MAP[$ext]:-sh}"
}

if ! command -v highlight >/dev/null 2>&1; then
  echo "Error: 'highlight' command not found in PATH." >&2
  exit 1
fi

mkdir -p "${OUTPUT_ROOT}"

pattern_args=()
for pattern in "${SUPPORTED_PATTERNS[@]}"; do
  if [ "${#pattern_args[@]}" -gt 0 ]; then
    pattern_args+=(-o)
  fi
  pattern_args+=(-name "${pattern}")
done

find "${WORKSPACE_DIR}" -type f \( "${pattern_args[@]}" \) \
  -not -name "*.html" | while IFS= read -r source_file; do
    rel_path="${source_file#"${WORKSPACE_DIR}/"}"
    rel_dir="$(dirname "${rel_path}")"
    [ "${rel_dir}" = "." ] && rel_dir=""

    output_dir="${OUTPUT_ROOT}"
    if [ -n "${rel_dir}" ]; then
      output_dir="${OUTPUT_ROOT}/${rel_dir}"
      mkdir -p "${output_dir}"
    fi

    base_name="$(basename "${source_file}")"
    output_file="${output_dir}/${base_name%.*}.html"
    syntax_type="$(get_syntax_by_extension "${source_file}")"
    # 使用相对路径作为 title（去掉绝对路径前缀）
    title="${rel_path}"
    echo "Formatting ${source_file} (${syntax_type}) -> ${output_file}"
    highlight -O html -S "${syntax_type}" -l --style solarized-dark --inline-css --doc-title "${title}" -o "${output_file}" "${source_file}"
  done

