#!/bin/sh

export APP_SETTINGS_FILE_NAME="TEST_BACKEND_KEY"
export DB_NAME="fastter_two"

./build/linux/x64/release/bundle/fastter_todo
