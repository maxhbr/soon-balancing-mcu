# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required(VERSION 3.20.0)

set(BOARD b_l4s5i_iot01a)
set(SHIELD adafruit_pca9685)

find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(soon-balancing-mcu)

FILE(GLOB app_sources src/*.c)
target_sources(app PRIVATE ${app_sources})
