#!/bin/bash

BASE_DIR=$(git rev-parse --show-toplevel)
URL="https://api.github.com/repos/hatena/Hatena-Blog-Workflows-Boilerplate/contents/.github/workflows"
FILES=$(curl -fsSL "$URL")

for row in $(echo "${FILES}" | jq -r '.[] | @base64'); do
    json=$(echo "${row}" | base64 --decode)
    download_url=$(echo "${json}" | jq -r '.download_url')
    path=$(echo "${json}" | jq -r '.path')

    curl -fsSL -o "$BASE_DIR/$path" "$download_url"
done
