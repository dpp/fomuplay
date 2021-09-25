FROM debian:bullseye

RUN apt update && apt upgrade -y && \
    apt install -y wget git udev


# Get version 1.6 of the tool chain
RUN cd /tmp && \
    wget https://github.com/im-tomu/fomu-toolchain/releases/download/v1.6/fomu-toolchain-Linux.tar.gz

RUN cd / && mkdir -p opt/fomu && cd /opt/fomu && \
    tar -xzf /tmp/fomu-toolchain-Linux.tar.gz


RUN echo '# Setup up paths for fomu' >> ~/.bashrc && \
    echo 'export FOMU_TOOLS=/opt/fomu/fomu-toolchain-Linux' >> ~/.bashrc && \
    echo 'export PATH=${FOMU_TOOLS}/bin:$PATH' >> ~/.bashrc && \
    echo 'export GHDL_PREFIX=[path-to-toolchain]/lib/ghdl' >> ~/.bashrc

# Set up udev stuff

RUN usermod -a -G plugdev root && \
    echo 'SUBSYSTEM=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="5bf0", MODE="0664", GROUP="plugdev"' >> /etc/udev/rules.d/99-fomu.rules


