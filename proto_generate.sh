rm -rf lib/schemaless_proto/
mkdir -p lib/schemaless_proto/

protoc --dart_out=grpc:lib/schemaless_proto \
    google/protobuf/empty.proto \
    google/protobuf/duration.proto \
    google/protobuf/struct.proto \
    google/protobuf/timestamp.proto \
    --proto_path=../schemaless-config-pull/proto/ \
    -Iprotos ../schemaless-config-pull/proto/types/*.proto ../schemaless-config-pull/proto/application/*.proto