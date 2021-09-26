FROM debian:bullseye

RUN apt update && apt upgrade -y && \
    apt install -y wget git udev screen make vim curl build-essential \
    autoconf automake autotools-dev libtool xutils-dev file python3-pip


# Get version 1.6 of the tool chain
RUN cd /tmp && \
    wget https://github.com/im-tomu/fomu-toolchain/releases/download/v1.6/fomu-toolchain-Linux.tar.gz

RUN cd / && mkdir -p opt/fomu && cd /opt/fomu && \
    tar -xzf /tmp/fomu-toolchain-Linux.tar.gz

# from https://github.com/liuchong/docker-rustup/blob/master/dockerfiles/plus/Dockerfile
ENV SSL_VERSION=1.0.2u

RUN curl https://www.openssl.org/source/openssl-$SSL_VERSION.tar.gz -O && \
    tar -xzf openssl-$SSL_VERSION.tar.gz && \
    cd openssl-$SSL_VERSION && ./config && make depend && make install && \
    cd .. && rm -rf openssl-$SSL_VERSION*

ENV OPENSSL_LIB_DIR=/usr/local/ssl/lib \
    OPENSSL_INCLUDE_DIR=/usr/local/ssl/include \
    OPENSSL_STATIC=1

# install all 3 toolchains
RUN curl https://sh.rustup.rs -sSf | \
    sh -s -- --default-toolchain stable -y 

ENV PATH=/root/.cargo/bin:$PATH

# end Rustup

RUN echo 'export PATH=/root/.cargo/bin:$PATH' >> ~/.bashrc

RUN rustup target add riscv32i-unknown-none-elf

# Install JVM and SBT

RUN apt install -y openjdk-11-jdk && \
    echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | tee /etc/apt/sources.list.d/sbt.list && \
    echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | tee /etc/apt/sources.list.d/sbt_old.list && \
    curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add && \
    apt update && \
    apt install -y sbt


RUN echo '# Setup up paths for fomu' >> ~/.bashrc && \
    echo 'export FOMU_TOOLS=/opt/fomu/fomu-toolchain-Linux' >> ~/.bashrc && \
    echo 'export PATH=${FOMU_TOOLS}/bin:$PATH' >> ~/.bashrc && \
    echo 'export GHDL_PREFIX=${FOMU_TOOLS}/lib/ghdl' >> ~/.bashrc && \
    echo 'export FOMU_REV=pvt' >> ~/.bashrc 

# Set up udev stuff

RUN usermod -a -G plugdev root && \
    echo 'SUBSYSTEM=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="5bf0", MODE="0664", GROUP="plugdev"' >> /etc/udev/rules.d/99-fomu.rules


