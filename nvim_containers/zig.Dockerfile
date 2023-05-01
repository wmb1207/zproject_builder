FROM wmb1207/awesome_nvim:latest

RUN dnf install -y gcc cmake llvm llvm-devel lld lld-devel binutils binutils-devel clang clang-devel git && \
    git clone https://github.com/ziglang/zig /zig

WORKDIR /zig

RUN mkdir build && \
    cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_PREFIX_PATH=/usr/local -DCMAKE_BUILD_TYPE=Release && \
    make install && git clone https://github.com/zigtools/zls /zls

WORKDIR /zls

RUN zig build -Doptimize=ReleaseSafe && cp zig-out/bin/zls /usr/local/bin/zls

WORKDIR /app

RUN rm -rf /zls && rm -rf /zig

