# Faker MySQL Server

一个用于安全测试的伪造 MySQL 服务器，主要用于测试 Java 反序列化漏洞。

## 功能说明

本工具模拟 MySQL 服务器行为，当客户端通过JDBC连接时，可以返回通过 ysoserial 或 ysuserial 生成的反序列化
payload，用于测试目标系统的反序列化漏洞。

## 编译

### Linux

```bash
GOOS=linux GOARCH=amd64 go build -o faker-mysql-server-linux-amd64 main.go
GOOS=linux GOARCH=386 go build -o faker-mysql-server-linux-386 main.go
GOOS=linux GOARCH=arm64 go build -o faker-mysql-server-linux-arm64 main.go
```

### Windows

```bash
build.bat
```

## 使用方法

### 基本参数

```bash
./faker-mysql-server-linux-amd64 -p 3306 -java java -ysoserial /root/ysoserial-0.0.6-SNAPSHOT-all.jar -ysuserial /root/ysuserial-1.5-su18-all.jar

# 指定LDAPDeserialize-tool.jar路径 payload 跟 yso 兼容
./faker-mysql-server-linux-amd64 -p 6666 -ysoserial .\LDAPDeserialize-tool.jar 
```

参数说明：

- `-p`: 监听端口，默认 3306
- `-java`: Java 可执行文件路径，默认使用 JAVA_HOME 路径
- `-ysoserial`: ysoserial.jar 文件路径(可指定LDAPDeserialize-tool.jar路径 payload 跟 yso 兼容)
- `-ysuserial`: ysuserial.jar 文件路径

#### URL 编码用法（支持特殊字符和空格）

当命令中包含空格或特殊字符时，需要对 username 进行 URL 编码：

| 命令                 | URL 编码后的 username                            |
|--------------------|----------------------------------------------|
| `calc`             | `yso_CommonsCollections5_calc`               |
| `touch /tmp/pwned` | `yso_CommonsCollections5_touch%20/tmp/pwned` |

## 工作原理

1. 服务器监听指定端口，等待客户端连接
2. 客户端连接时，服务器发送 MySQL 握手包
3. 服务器从客户端认证数据包中提取用户名（偏移量 36 开始）
4. **对用户名进行 URL 解码**，支持特殊字符和空格
5. 解析用户名前缀判断使用的 payload 类型（yso/ysu）
6. 当客户端执行 `SHOW SESSION STATUS` 查询时：
    - 解析用户名获取 gadget 类型和命令
    - 调用 ysoserial/ysuserial 生成反序列化 payload
    - 将 payload 包装在查询结果中返回

### username 格式

```
{前缀}_{gadget}_{命令}
```

- **前缀**: `yso` (ysoserial) 或 `ysu` (ysuserial)
- **gadget**: 反序列化利用链名称，如 `CommonsCollections5`
- **命令**: 要执行的命令，支持 URL 编码

### URL 解码说明

- 服务器会自动对提取的 username 进行 URL 解码
- 如果解码失败，会保留原始值并记录警告日志
- 这使得可以在 payload 命令中使用空格、引号等特殊字符

## 环境要求

- Go 1.20+
- Java 运行环境
- ysoserial 或 ysuserial jar 文件

## 更新日志

### v0.4 (2025-12-31)

- ✨ 新增 username URL 解码功能，支持在 payload 命令中使用特殊字符和空格
- 🔧 新增 `port` 参数，可以自定义端口
- ⬆️ Go 版本要求升级到 1.20

## 注意事项

本工具仅供安全研究和授权渗透测试使用，请勿用于非法用途。
