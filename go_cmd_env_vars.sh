export GOROOT=/home/ming/go
export GOPATH=/home/ming/go_project
export PATH=$PATH:/home/ming/go/bin

# go get golang.org/x error
# solution 1:
export GO111MODULE=on
export GOPROXY=https://goproxy.io
#
# solution 2:
# export http_proxy=http://proxyAddress:port
# export https_proxy=http://proxyAddress:port
# export all_proxy=http://proxyAddress:port
