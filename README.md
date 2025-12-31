# Faker MySQL Server

一个用于安全测试的伪造 MySQL 服务器，主要用于测试 Java 反序列化漏洞。

## 功能说明

本工具模拟 MySQL 服务器行为，当客户端通过JDBC连接时，可以返回通过 ysoserial 或 ysuserial 生成的反序列化 payload，用于测试目标系统的反序列化漏洞。

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
```

参数说明：
- `-p`: 监听端口，默认 3306
- `-java`: Java 可执行文件路径，默认使用 JAVA_HOME 路径
- `-ysoserial`: ysoserial.jar 文件路径
- `-ysuserial`: ysuserial.jar 文件路径


## 工作原理

1. 服务器监听指定端口，等待客户端连接
2. 客户端连接时，服务器发送 MySQL 握手包
3. 解析客户端发送的用户名，根据前缀判断使用的 payload 类型（yso/ysu）
4. 当客户端执行 `SHOW SESSION STATUS` 查询时：
   - 解析用户名获取 gadget 类型和命令
   - 调用 ysoserial/ysuserial 生成反序列化 payload
   - 将 payload 包装在查询结果中返回

## 环境要求

- Go 1.x
- Java 运行环境
- ysoserial 或 ysuserial jar 文件

## 版本

v0.4

## 注意事项

本工具仅供安全研究和授权渗透测试使用，请勿用于非法用途。
