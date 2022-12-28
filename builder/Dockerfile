FROM zephyrprojectrtos/ci:latest

RUN set -x \
    && apt-get update && apt-get install -y \
        jq \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /zephyrproject

ENV ZEPHYR_TOOLCHAIN_VARIANT zephyr

ADD entrypoint.sh "/entrypoint.sh"
RUN set -x \
    && sudo chmod +x "/entrypoint.sh"
ENTRYPOINT "/entrypoint.sh"
