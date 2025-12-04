# .NET 9 通用运行容器

这是一个通用的 .NET 9 运行时容器，可以运行任何已发布的 .NET 9 应用程序。只需挂载包含发布文件的目录，并指定可执行文件名称即可。

## 功能特点

- 基于官方 .NET 9 ASP.NET 运行时镜像
- 支持 linux/amd64 和 linux/arm64 平台
- 通过环境变量配置，无需重新构建镜像
- 支持挂载本地发布目录

## 快速开始

### 1. 发布你的 .NET 应用

```bash
dotnet publish -c Release -o ./publish
```

### 2. 运行容器

```bash
docker run -d \
  -e APP_NAME=YourAppName \
  -v /path/to/publish:/app/publish \
  -p 8080:8080 \
  ghcr.io/jilin6654/dotnet9_container:latest
```

## 环境变量

| 变量名 | 必需 | 描述 | 示例 |
|--------|------|------|------|
| `APP_NAME` | 是 | 可执行文件名称（不带 .dll 扩展名） | `MyWebApp` |
| `APP_ARGS` | 否 | 传递给应用程序的命令行参数 | `--urls=http://+:8080` |

## 使用示例

### 运行 Web API 应用

```bash
docker run -d \
  --name mywebapi \
  -e APP_NAME=MyWebApi \
  -e APP_ARGS="--urls=http://+:5000" \
  -v $(pwd)/publish:/app/publish \
  -p 5000:5000 \
  ghcr.io/jilin6654/dotnet9_container:latest
```

### 运行控制台应用

```bash
docker run -it \
  -e APP_NAME=MyConsoleApp \
  -e APP_ARGS="arg1 arg2" \
  -v $(pwd)/publish:/app/publish \
  ghcr.io/jilin6654/dotnet9_container:latest
```

### 使用 Docker Compose

```yaml
version: '3.8'

services:
  myapp:
    image: ghcr.io/jilin6654/dotnet9_container:latest
    environment:
      - APP_NAME=MyWebApp
      - APP_ARGS=--urls=http://+:8080
    volumes:
      - ./publish:/app/publish
    ports:
      - "8080:8080"
    restart: unless-stopped
```

## 注意事项

1. **发布配置**: 确保使用 `dotnet publish` 命令发布应用，而不是 `dotnet build`
2. **目标框架**: 应用必须针对 .NET 9 构建
3. **依赖项**: 所有依赖项应包含在发布目录中
4. **端口**: 默认暴露 80、443 和 8080 端口，可根据需要映射

## 自行构建镜像

```bash
# 克隆仓库
git clone https://github.com/jilin6654/dotnet9_container.git
cd dotnet9_container

# 构建镜像
docker build -t dotnet9_container:local .

# 运行
docker run -e APP_NAME=MyApp -v ./publish:/app/publish dotnet9_container:local
```

## 许可证

MIT License
