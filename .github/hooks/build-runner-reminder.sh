#!/usr/bin/env bash

files=$(git diff --name-only)

for file in $files; do
  if [[ "$file" == *.dart ]] && (
    [[ "$file" == *datasource* ]] ||
    [[ "$file" == *data_source* ]] ||
    [[ "$file" == *_response.dart ]] ||
    [[ "$file" == *_request.dart ]]
  ); then
    echo "⚠️ Code-generated file changed."
    echo "Run:"
    echo "dart run build_runner build --delete-conflicting-outputs"
    exit 0
  fi
done