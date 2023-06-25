#!/bin/sh

echo "evil-mysql-server"
echo "移除dist目录"

rm -rf ./dist
mkdir dist
mkdir -p ./dist/tmp


# windows
CGO_ENABLED=0 GOOS=windows GOARCH=386   go build -a -ldflags "-s -w" -o ./dist/tmp/windows32.exe main.go
echo "构建evil-mysql-server-win32 包成功"
CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -a -ldflags "-s -w" -o ./dist/tmp/windows64.exe main.go
echo "构建evil-mysql-server-win64 包成功"

# linux 86  64
CGO_ENABLED=0 GOOS=linux GOARCH=386     go build -a -ldflags "-s -w" -o ./dist/tmp/linux32 main.go
echo "构建evil-mysql-server-linux32 包成功"
CGO_ENABLED=0 GOOS=linux GOARCH=amd64   go build -a -ldflags "-s -w" -o ./dist/tmp/linux64 main.go
echo "构建evil-mysql-server-linux64 包成功"

# linux arm  arm64
CGO_ENABLED=0 GOOS=linux GOARCH=arm     go build -a -ldflags "-s -w" -o ./dist/tmp/linuxarm main.go
echo "构建evil-mysql-server-linux-arm 包成功"
CGO_ENABLED=0 GOOS=linux GOARCH=arm64   go build -a -ldflags "-s -w" -o ./dist/tmp/linuxarm64 main.go
echo "构建evil-mysql-server-linux-arm64 包成功"

# 需要安装upx软件 https://github.com/upx/upx
#echo "upx压缩开始 需要安装upx软件 https://github.com/upx/upx"
#/home/hai/upx/upx --brute ./dist/tmp/linux32
#/home/hai/upx/upx --brute ./dist/tmp/linux64
#/home/hai/upx/upx --brute ./dist/tmp/linuxarm
#/home/hai/upx/upx --brute ./dist/tmp/linuxarm64
#echo "upx压缩结束"


tar zcf ./dist/duck-cc-client.tar.gz -C ./dist/tmp .
echo "生成evil-mysql-server.tar.gz成功"

rm -rf ./dist/tmp
echo "移除缓存目录dist/tmp"


echo "构建evil-mysql-server完成"
echo "Success"

# garble 混淆后无法正常运行 gob不能正常反序列化
#GOPRIVATE='*' /Users/admin/go/bin/garble -literals -tiny -seed=random build main.go
