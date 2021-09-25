# FOMU stuff

This repo is tooling and documentation for [dpp](https://twitter.com/dpp)'s
exploration of the [FOMU](https://tomu.im/fomu.html) FPGA in a USB form factor
device the the [Workshop](https://workshop.fomu.im/en/latest/index.html).


All the code was run on an Ubuntu 20.04 system with Docker
installed.

## Building the container

The Docker container will allow you to run all the code.

The container is built against version 1.6 of the [FOMU toolchain](https://github.com/im-tomu/fomu-toolchain/tree/v1.6).

To build the container (from within the same directory
this file is in): `docker build . --tag fomu`

To test if things work:

* `docker run -ti --rm --privileged -v /dev/bus/usb:/dev/bus/usb fomu` # start the container
* `yosys` # start the tool... you should see "yosys>" prompt
* `exit` # exit yosys
* `dfu-util -l` # check to see if the dfu-util system can see your FOMU... look for Found DFU: [1209:5bf0] ver=0101, devnum=29, cfg=1, intf=0, path="1-3", alt=0, name="Fomu PVT running DFU Bootloader v2.0.3", serial="UNKNOWN"
* Note that if the version of the "Bootloader" is less than 2.0.3, please [update the bootloader](https://workshop.fomu.im/en/latest/bootloader.html#bootloader-update)






