#!/bin/bash

project="forward"

declare -A targets=(
  ["linux_x86-64"]="x86_64-unknown-linux-gnu"
)

mkdir -p release

for platform in "${!targets[@]}"; do
  target="${targets[$platform]}"
  rustup target add "$target"
  cargo build --target="$target" --release
  strip -s ./target/"$target"/release/"$project"
  upx -9 ./target/"$target"/release/"$project"
  7z a ./release/"$project"_"$platform".7z ./target/"$target"/release/"$project" README.md LICENSE
  sha1sum ./release/"$project"_"$platform".7z > ./release/"$project"_"$platform".7z.sha1
done
