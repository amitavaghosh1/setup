#!/bin/bash

set -e

DARWIN_URL="https://github.com/bufbuild/buf/releases/download/v1.8.0/buf-Darwin-x86_64"
LINUX_URL="https://github.com/bufbuild/buf/releases/download/v1.8.0/buf-Linux-x86_64"

REMOTE_BASE_URL="https://raw.githubusercontent.com/amitavaghosh1/setup/main/golang/grpcproj"
BUF_CONFIG_URL="$REMOTE_BASE_URL/buf.gen.yaml"
TOOLS_FILE_URL="$REMOTE_BASE_URL/tools.go"

DEFAULT_PROTOS_SCRIPT_URL="$REMOTE_BASE_URL/install_protos.sh"
API_GENERATOR_DOCKER_FILE="$REMOTE_BASE_URL/Dockerfile"

MAKE_FILE_PARTIAL_URL="$REMOTE_BASE_URL/Makefile"
SAMPLE_PROTO_FILE_TEMPLATE="$REMOTE_BASE_URL/greeter.proto"

SAMPLE_MAIN_GO="$REMOTE_BASE_URL/main.go.sample"


function download_buf() {
    os=$(uname -s)

    if [[ ! -z "$(which buf)" ]]; then
        echo "already downloaded"
        return
    fi

    GO111MODULE=on go install github.com/bufbuild/buf/cmd/buf@v1.8.0 
}

function has_buf() {
  if [[ -z "$(which buf)" ]]; then
      echo "please install buf"
      echo "https://docs.buf.build/installation"
      exit 1
  fi
}

function fetch_buf_config() {
    curl -sk "$BUF_CONFIG_URL" -o buf.gen.yaml
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
    curl -sk "$TOOLS_FILE_URL" -o tools.go
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
    curl -sk "$DEFAULT_PROTOS_SCRIPT_URL" | bash
}

function fetch_generator_dockerfile() {
    mkdir -p infrafiles/genapi
    curl -sk "$API_GENERATOR_DOCKER_FILE" -o infrafiles/genapi/Dockerfile
}

function fetch_makefile() {
    curl -sk "$MAKE_FILE_PARTIAL_URL" | tee -a Makefile
}

function setup_sample_directory() {
  mkdir -p greeter/contracts
  mkdir -p greeter/protos

  appname="$(basename $(pwd))" envsubst < <(curl -sk "$SAMPLE_PROTO_FILE_TEMPLATE")  > greeter/protos/greeter.proto
  mkdir -p docs/slatedocs

  curl -sk "$SAMPLE_MAIN_GO" -o main.go.sample
}

echo "checking if go is present"
has_go


echo "download and install buff"
download_buf

echo "verify buf in PATH"
has_buf


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


