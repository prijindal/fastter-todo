rm -rf lib/schemaless_proto/
mkdir -p lib/schemaless_proto/

protoc --dart_out=grpc:lib/schemaless_proto \
    google/protobuf/empty.proto \
    google/protobuf/duration.proto \
    google/protobuf/struct.proto \
    google/protobuf/timestamp.proto \
    --proto_path=../schemaless/application/proto \
    --proto_path=$HOME/.cache/buf/v3/modules/b5/buf.build/bufbuild/protovalidate/52f32327d4b045a79293a6ad4e7e1236/files \
    -Iprotos ../schemaless/application/proto/**/**/*.proto
