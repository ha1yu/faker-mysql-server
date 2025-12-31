@REM 删除bin目录下的所有文件
del /Q /F bin\*

set CGO_ENABLED=0


set GOOS=windows
set GOARCH=386
go build -trimpath -ldflags "-s -w" -o bin/faker-mysql-server-win-386.exe main.go

set GOOS=windows
set GOARCH=amd64
go build -trimpath -ldflags "-s -w" -o bin/faker-mysql-server-win-amd64.exe main.go

set GOOS=linux
set GOARCH=386
go build -trimpath -ldflags "-s -w" -o bin/faker-mysql-server-linux-386 main.go

set GOOS=linux
set GOARCH=amd64
go build -trimpath -ldflags "-s -w" -o bin/faker-mysql-server-linux-amd64 main.go

set GOOS=linux
set GOARCH=arm64
go build -trimpath -ldflags "-s -w" -o bin/faker-mysql-server-linux-arm64 main.go
