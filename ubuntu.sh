#!/bin/bash
set -e

OUTPUT="ubuntu_baseline.json"

# APT packages
apt list --installed 2>/dev/null | grep -v "Listing..." > apt_packages.txt

# Installed programs (common bin dirs)
ls /usr/bin > usr_bin.txt
ls /usr/local/bin > usr_local_bin.txt

# Python packages
pip3 list --format=json > python_global.json 2>/dev/null || echo "[]">python_global.json

# Node.js packages (global)
npm ls -g --json > node_global.json 2>/dev/null || echo "{}">node_global.json

# Ruby gems
gem list --local > ruby_global.txt 2>/dev/null || echo "" > ruby_global.txt

# Perl packages
perldoc -t perllocal > perl_global.txt 2>/dev/null || echo "" > perl_global.txt

# PHP Composer global
composer global show --format=json > php_global.json 2>/dev/null || echo "{}">php_global.json

# R libraries
Rscript -e 'installed.packages()[,c("Package","Version")]' > r_global.txt 2>/dev/null || echo "" > r_global.txt

# Go modules (not packages, but system modules)
go list -m all > go_global.txt 2>/dev/null || echo "" > go_global.txt

# Rust crates (global)
cargo install --list > rust_global.txt 2>/dev/null || echo "" > rust_global.txt

# Java (list installed JARs in common dirs)
find /usr/lib -name "*.jar" > java_global.txt 2>/dev/null

# .NET installed SDKs
dotnet --list-sdks > dotnet_sdks.txt 2>/dev/null || echo "" > dotnet_sdks.txt
dotnet --list-runtimes > dotnet_runtimes.txt 2>/dev/null || echo "" > dotnet_runtimes.txt

# Combine everything
jq -n \
  --slurpfile apt    apt_packages.txt \
  --slurpfile usrbin usr_bin.txt \
  --slurpfile usrloc usr_local_bin.txt \
  --slurpfile py     python_global.json \
  --slurpfile node   node_global.json \
  --slurpfile ruby   ruby_global.txt \
  --slurpfile perl   perl_global.txt \
  --slurpfile php    php_global.json \
  --slurpfile r      r_global.txt \
  --slurpfile go     go_global.txt \
  --slurpfile rust   rust_global.txt \
  --slurpfile java   java_global.txt \
  --slurpfile dotnet_sdk dotnet_sdks.txt \
  --slurpfile dotnet_rt  dotnet_runtimes.txt \
  '{apt: $apt, usr_bin:$usrbin, usr_local_bin:$usrloc,
    python:$py, node:$node, ruby:$ruby, perl:$perl,
    php:$php, r:$r, go:$go, rust:$rust, java:$java,
    dotnet_sdk:$dotnet_sdk, dotnet_runtime:$dotnet_rt}' \
  > "$OUTPUT"

echo "Generated $OUTPUT"
