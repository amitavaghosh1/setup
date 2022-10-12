mkdir -p google/api
curl -s https://raw.githubusercontent.com/googleapis/googleapis/master/google/api/http.proto > google/api/http.proto
curl -s https://raw.githubusercontent.com/googleapis/googleapis/master/google/api/annotations.proto > google/api/annotations.proto
curl -s https://raw.githubusercontent.com/googleapis/googleapis/master/google/api/httpbody.proto > google/api/httpbody.proto

mkdir -p protoc-gen-openapiv2/options
curl -s https://raw.githubusercontent.com/grpc-ecosystem/grpc-gateway/master/protoc-gen-openapiv2/options/annotations.proto > protoc-gen-openapiv2/options/annotations.proto
curl -s https://raw.githubusercontent.com/grpc-ecosystem/grpc-gateway/master/protoc-gen-openapiv2/options/openapiv2.proto > protoc-gen-openapiv2/options/openapiv2.proto

