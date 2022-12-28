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
mkdir -p \
   "${repo}/_build" \
   "${repo}/_zephyr" \
   "${repo}/_modules" \
   "${repo}/_tools" \
   "${repo}/_bootloader"
podman run --rm -it \
    -v "${repo}:/zephyrproject/${path}" \
    -v "${repo}/_build:/zephyrproject/build" \
    -v "${repo}/_zephyr:/zephyrproject/zephyr" \
    -v "${repo}/_modules:/zephyrproject/modules" \
    -v "${repo}/_tools:/zephyrproject/tools" \
    -v "${repo}/_bootloader:/zephyrproject/bootloader" \
    -e path="${path}" \
    "$tag"
