#!/usr/bin/env bash
#
set -euo pipefail

context="$( cd -- "$( dirname -- "$(readlink -f "${BASH_SOURCE[0]}")" )" &> /dev/null && pwd )"
repo="$(readlink -f "${context}/..")"
path="$(cat "$repo/west.yml" | yq -r '.manifest.self.path')"
tag="maxhbr/${path}-zephyrbuilder"

if [[ $# -gt 0 && "$1" == "clean" ]]; then
    shift
    podman volume rm "${path}-zephyr-modules" || true
    podman volume rm "${path}-zephyr" || true
    podman volume rm "${path}-zephyr-tools"|| true
    podman volume rm "${path}-zephyr-bootloader" || true
fi
if [[ $# -gt 0 && "$1" == "build" ]]; then
    shift
    podman build "$context" --tag "$tag"
fi

set -x
mkdir -p build
podman run --rm -it \
    -v "$repo:/zephyrproject/${path}" \
    -v "$repo/build:/zephyrproject/build" \
    -v "${path}-zephyr:/zephyrproject/zephyr" \
    -v "${path}-zephyr-modules:/zephyrproject/modules" \
    -v "${path}-zephyr-tools:/zephyrproject/tools" \
    -v "${path}-zephyr-bootloader:/zephyrproject/bootloader" \
    -e path="${path}" \
    "$tag"
