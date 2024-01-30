#!/bin/sh

set -euxo pipefail

yum install -y alsa-lib-devel

cmake -S portaudio -B build -D CMAKE_BUILD_TYPE=Release -D PA_USE_JACK=OFF
cmake --build build

ldd build/libportaudio.so
