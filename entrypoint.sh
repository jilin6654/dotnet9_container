#!/bin/bash
set -e

# 检查必需的环境变量
if [ -z "$APP_NAME" ]; then
    echo "错误: 请设置 APP_NAME 环境变量来指定要运行的应用程序名称"
    echo ""
    echo "使用方法:"
    echo "  docker run -e APP_NAME=YourAppName -v /path/to/publish:/app/publish ghcr.io/jilin6654/dotnet9_container"
    echo ""
    echo "环境变量:"
    echo "  APP_NAME  - 必需，可执行文件名称（不带 .dll 扩展名）"
    echo "  APP_ARGS  - 可选，传递给应用程序的参数"
    echo ""
    echo "示例:"
    echo "  docker run -e APP_NAME=MyWebApp -v ./publish:/app/publish -p 8080:8080 ghcr.io/jilin6654/dotnet9_container"
    exit 1
fi

APP_PATH="/app/publish/${APP_NAME}.dll"

# 检查应用程序文件是否存在
if [ ! -f "$APP_PATH" ]; then
    echo "错误: 找不到应用程序文件: $APP_PATH"
    echo ""
    echo "请确保:"
    echo "  1. 已正确挂载包含发布文件的目录到 /app/publish"
    echo "  2. APP_NAME 环境变量设置正确（当前值: $APP_NAME）"
    echo ""
    echo "/app/publish 目录内容:"
    ls -la /app/publish/ 2>/dev/null || echo "  (目录为空或不存在)"
    exit 1
fi

echo "启动应用程序: $APP_NAME"
echo "应用路径: $APP_PATH"
echo "应用参数: $APP_ARGS"
echo "----------------------------------------"

# 运行 .NET 应用程序
exec dotnet "$APP_PATH" $APP_ARGS
