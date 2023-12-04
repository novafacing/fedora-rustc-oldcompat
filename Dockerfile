# hadolint global ignore=DL3033,SC3044
FROM fedora:20

ENV PATH="${PATH}:/root/.cargo/bin/"

RUN yum -y update && \
    yum -y install \
        coreutils \
        gcc \
        gcc-c++ \
        make && \
    yum clean all

COPY rustup-init /install/rustup-init
COPY make-4.4.1.tar.gz /install/make-4.4.1.tar.gz
COPY cmake-3.28.0-rc5-linux-x86_64.tar.gz /install/cmake-3.28.0-rc5-linux-x86_64.tar.gz
COPY llvm-5.0.2.src.tar.xz /install/llvm-5.0.2.src.tar.xz
COPY cfe-5.0.2.src.tar.xz /install/cfe-5.0.2.src.tar.xz

RUN chmod +x /install/rustup-init && \
    /install/rustup-init -y --default-toolchain nightly && \
    mkdir -p /make && \
    tar -C /make --strip-components=1 -xvf /install/make-4.4.1.tar.gz && \
    pushd /make && \
    ./configure && \
    make && \
    make install && \
    make clean && \
    popd && \
    tar -C /usr/local/ --strip-components=1 -xvf /install/cmake-3.28.0-rc5-linux-x86_64.tar.gz && \
    mkdir -p /llvm/tools/clang && \
    tar -C /llvm --strip-components=1 -xvf /install/llvm-5.0.2.src.tar.xz && \
    tar -C /llvm/tools/clang --strip-components=1 -xvf /install/cfe-5.0.2.src.tar.xz && \
    mkdir -p /llvm/build && \
    pushd /llvm/build && \
    cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE="MinSizeRel" -DLLVM_TARGETS_TO_BUILD="X86" .. && \
    make -j "$(nproc)" && \
    make install && \
    make clean && \
    rm -rf /llvm/build/ && \
    popd && \
    rm -rf /make /llvm

WORKDIR /
