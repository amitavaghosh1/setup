#!/bin/bash

set -e

DARWIN_URL="https://github.com/bufbuild/buf/releases/download/v1.8.0/buf-Darwin-x86_64"

LINUX_URL="https://github.com/bufbuild/buf/releases/download/v1.8.0/buf-Linux-x86_64"


function assert_instal_dirctory_in_path() {
    if [[ -z "$(go env GOBIN)" ]]; then
        echo "please add GOBIN to your env. with export GOBIN=./some/empty/directory"
        exit 1
    fi
}

function download_buf() {
    os=$(uname -s)

    if [[ ! -z "$(which buf)" ]]; then
        echo "already downloaded"
        return
    fi


    if [[ "$os" == "Linux" ]]; then
        curl -sL "$LINUX_URL" -o buf
    else
        curl -sL "$DARWIN_URL" -o buf
    fi

    chmod +x ./buf
    # cp ./buf "$GOBIN" 
}

function fetch_buf_config() {
    curl -sk 'https://gist.githubusercontent.com/amitavaghosh1/876fb14756caf0e0668a4023e2b701cd/raw/e096fb51cdef29012dc236adf2797e578bafa929/buf.gen.yaml' -o buf.gen.yaml
}

function has_go() {
  if [[ -z "$(which go)" ]]; then
      echo "please install go"
      exit 1
  fi
}

function setup_go_repo() {
    if [[ -f "go.mod" ]];then
        echo "present"
    else
        appname="$(basename $(pwd))"
        go mod init "$appname"
    fi
}

function all_things_go() {
    go mod tidy
    go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger
    go install \
        github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway \
        github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2 \
        google.golang.org/protobuf/cmd/protoc-gen-go \
        google.golang.org/grpc/cmd/protoc-gen-go-grpc \
        github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger
}

function fetch_tools_go() {
    curl -sk 'https://gist.githubusercontent.com/amitavaghosh1/876fb14756caf0e0668a4023e2b701cd/raw/803a41546bc9d9a738b9e21630a4bf4c563366a0/tools.go' -o tools.go
}

function has_npm() {
  if [[ -z "$(which npm)" ]]; then
      echo "please install npm"
      exit 1
  fi
}

function all_things_node() {
    npm install -g widdershins
}

function install_required_protos() {
    curl -sk 'https://gist.githubusercontent.com/amitavaghosh1/876fb14756caf0e0668a4023e2b701cd/raw/6737697b28cfab3bdb7706999979d9211f565520/install_protos.sh' | bash
}

function fetch_generator_dockerfile() {
    curl -sk 'https://gist.githubusercontent.com/amitavaghosh1/876fb14756caf0e0668a4023e2b701cd/raw/2e2d35655086af810c1dcb18e86152bb76f53181/Dockerfile' -o genapi.Dockerfile
}

function fetch_makefile() {
    curl -sk 'https://gist.githubusercontent.com/amitavaghosh1/876fb14756caf0e0668a4023e2b701cd/raw/8928a51cab9999f9a022ff5f5654b1abf5011e46/Makefile' | tee -a Makefile
}

function setup_sample_directory() {
  mkdir -p greeter/contracts
  mkdir -p greeter/protos

  appname="$(basename $(pwd))" envsubst < <(curl -sk 'https://gist.githubusercontent.com/amitavaghosh1/876fb14756caf0e0668a4023e2b701cd/raw/2686ec178c8c4a07fc82402b4dc58cdb78b18686/greeter.proto')  > greeter/protos/greeter.proto
  mkdir -p docs/slatedocs
}

echo "checking if go is present"
has_go

echo "validate if a directory is present in PATH"
assert_instal_dirctory_in_path

echo "download and install buff"
download_buf

echo "fetch buf config"
fetch_buf_config

echo "getting necessary files for go"
setup_go_repo
fetch_tools_go
all_things_go

echo "getting node dependencies for slate"
has_npm
all_things_node

echo "fetching required protos. this can be configured from remote"
install_required_protos

echo "fetch infra files"
fetch_generator_dockerfile
fetch_makefile

echo "setting up sample directory"
setup_sample_directory

echo "run make gen, to generate the contracts and docs"


