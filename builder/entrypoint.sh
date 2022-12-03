#!/usr/bin/env bash

set -euo pipefail
set -x

[[ -d ".west" ]] || west init -l "$path"
west update #-f always
west config -l
west zephyr-export
west build \
    -s "$path" \
    -p always \
    -d ./build || bash
