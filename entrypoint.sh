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
    echo "  APP_NAME  - 必需，可执行文件名称"
    echo "  APP_ARGS  - 可选，传递给应用程序的参数"
    echo ""
    echo "示例:"
    echo "  docker run -e APP_NAME=MyWebApp -v ./publish:/app/publish -p 8080:8080 ghcr.io/jilin6654/dotnet9_container"
    exit 1
fi

APP_DIR="/app/publish"
APP_DLL="${APP_DIR}/${APP_NAME}.dll"
APP_EXE="${APP_DIR}/${APP_NAME}"

# 检查应用程序文件是否存在（优先检查可执行文件，其次检查 DLL）
if [ -f "$APP_EXE" ] && [ -x "$APP_EXE" ]; then
    # 单文件发布模式：直接运行可执行文件
    echo "启动应用程序: $APP_NAME (单文件模式)"
    echo "应用路径: $APP_EXE"
    echo "应用参数: $APP_ARGS"
    echo "----------------------------------------"
    exec "$APP_EXE" $APP_ARGS
elif [ -f "$APP_EXE" ]; then
    # 可执行文件存在但没有执行权限，添加权限后运行
    chmod +x "$APP_EXE"
    echo "启动应用程序: $APP_NAME (单文件模式)"
    echo "应用路径: $APP_EXE"
    echo "应用参数: $APP_ARGS"
    echo "----------------------------------------"
    exec "$APP_EXE" $APP_ARGS
elif [ -f "$APP_DLL" ]; then
    # 框架依赖发布模式：使用 dotnet 运行 DLL
    echo "启动应用程序: $APP_NAME (框架依赖模式)"
    echo "应用路径: $APP_DLL"
    echo "应用参数: $APP_ARGS"
    echo "----------------------------------------"
    exec dotnet "$APP_DLL" $APP_ARGS
else
    echo "错误: 找不到应用程序文件"
    echo ""
    echo "已尝试查找:"
    echo "  - $APP_EXE (单文件发布)"
    echo "  - $APP_DLL (框架依赖发布)"
    echo ""
    echo "请确保:"
    echo "  1. 已正确挂载包含发布文件的目录到 /app/publish"
    echo "  2. APP_NAME 环境变量设置正确（当前值: $APP_NAME）"
    echo ""
    echo "/app/publish 目录内容:"
    ls -la /app/publish/ 2>/dev/null || echo "  (目录为空或不存在)"
    exit 1
fi
