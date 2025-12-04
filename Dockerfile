# 使用 .NET 9 运行时作为基础镜像
FROM mcr.microsoft.com/dotnet/aspnet:9.0

# 设置工作目录
WORKDIR /app

# 设置环境变量
# APP_NAME: 可执行文件名称（不带扩展名）
# APP_ARGS: 可选的应用程序参数
ENV APP_NAME=""
ENV APP_ARGS=""

# 创建应用目录（用于挂载）
RUN mkdir -p /app/publish

# 设置入口点脚本
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 暴露常用端口（可根据需要调整）
EXPOSE 80
EXPOSE 443
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
