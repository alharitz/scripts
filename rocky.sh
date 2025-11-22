#!/bin/bash
set -e

OUTPUT="rocky_baseline.json"

dnf list installed > dnf_packages.txt

ls /usr/bin > usr_bin.txt
ls /usr/local/bin > usr_local_bin.txt

pip3 list --format=json > python_global.json 2>/dev/null || echo "[]">python_global.json
npm ls -g --json > node_global.json 2>/dev/null || echo "{}">node_global.json
gem list --local > ruby_global.txt 2>/dev/null || echo "" > ruby_global.txt
composer global show --format=json > php_global.json 2>/dev/null || echo "{}">php_global.json

jq -n \
  --slurpfile dnf dnf_packages.txt \
  --slurpfile usrbin usr_bin.txt \
  --slurpfile usrloc usr_local_bin.txt \
  --slurpfile py python_global.json \
  --slurpfile node node_global.json \
  --slurpfile ruby ruby_global.txt \
  --slurpfile php php_global.json \
  '{dnf:$dnf, usr_bin:$usrbin, usr_local_bin:$usrloc,
    python:$py, node:$node, ruby:$ruby, php:$php}' \
  > "$OUTPUT"

echo "Generated $OUTPUT"
