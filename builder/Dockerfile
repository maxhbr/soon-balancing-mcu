FROM zephyrprojectrtos/ci:latest

WORKDIR /zephyrproject

ENV ZEPHYR_TOOLCHAIN_VARIANT zephyr

ADD entrypoint.sh "/entrypoint.sh"
RUN set -x \
    && sudo chmod +x "/entrypoint.sh"
ENTRYPOINT "/entrypoint.sh"
