# value 若负数要带-
value=$1

# 使用正则表达式检查是否包含非数字字符
if [[ "$value" =~ [^0-9-] ]]; then
        # 将十六进制字符串转换为十进制无符号整数
        unsigned_value=$(printf "%llu\n" "0x$value")

        # 使用 bc 进行有符号整数转换和比较
        signed_value=$(echo "obase=10; ibase=10; $unsigned_value - 18446744073709551616" | bc)
        is_negative=$(echo "$unsigned_value >= 9223372036854775808" | bc)

        if [ "$is_negative" -eq 0 ]; then
                signed_value=$unsigned_value
        fi

        echo "输入十六进制:" $value, "输出十进制:" $signed_value
else
        echo "输入十进制:" $value, "输出十六进制:" `printf "%x" $value`
fi

