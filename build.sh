#!/bin/bash

TAG=0.0.1

curl -o cfe-5.0.2.src.tar.xz https://releases.llvm.org/5.0.2/cfe-5.0.2.src.tar.xz
curl -o llvm-5.0.2.src.tar.xz https://releases.llvm.org/5.0.2/llvm-5.0.2.src.tar.xz
curl -o make-4.4.1.tar.gz https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz
curl -o rustup-init https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init
curl -L -o cmake-3.28.0-rc5-linux-x86_64.tar.gz \
    https://github.com/Kitware/CMake/releases/download/v3.28.0-rc5/cmake-3.28.0-rc5-linux-x86_64.tar.gz
chmod +x rustup-init

docker build -t fedora-rustc-oldcompat .
docker tag fedora-rustc-oldcompat "novafacing/fedora-rustc-oldcompat:${TAG}"
docker push "novafacing/fedora-rustc-oldcompat:${TAG}"
