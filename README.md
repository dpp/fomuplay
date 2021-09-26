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
this file is in): `./build.sh`

This script builds the `fomu` Docker image.

To test if things work:

* `./run.sh` # start the container
* `yosys` # start the tool... you should see "yosys>" prompt
* `exit` # exit yosys
* `dfu-util -l` # check to see if the dfu-util system can see your FOMU... look for Found DFU: [1209:5bf0] ver=0101, devnum=29, cfg=1, intf=0, path="1-3", alt=0, name="Fomu PVT running DFU Bootloader v2.0.3", serial="UNKNOWN"
* Note that if the version of the "Bootloader" is less than 2.0.3, please [update the bootloader](https://workshop.fomu.im/en/latest/bootloader.html#bootloader-update)

## Running the workshop

So, you've got your container running. Yay!

Now, let's run through the first example, [Python on Fomu](https://workshop.fomu.im/en/latest/python.html#python-on-fomu).

Start the container (assuming this project is checked out in the same directory as the [workshop](https://github.com/im-tomu/fomu-workshop)):   
`./run.sh`

From the prompt, make sure `dfu-util` can see the device: `dfu-util -l` and look for `name="Fomu PVT running DFU Bootloader v2.0.3"`.

If that did not work, try removing the Fomu from the USB socket
on your machine, and then re-insert. This will return the Fomu
to the original code rather than a new set of gate code.

Next, load micro-Python onto the Fomu: 
`dfu-util -D /workshop/micropython-fomu.dfu`

And check out the interpretter: `screen /dev/ttyACM*`

To exit `screen` (this is harder than existing vi)
type: `ctrl-A \` and you'll be prompted to exit.


## Other workshop examples

The other workshop examples have been tested including the
Rust and Chisel/Scala examples. Additionally, the `run.sh`
script creates a cache directory on the host so Scala/sbt
and Rust libraries, etc. are cached between container
invocations.

## Pull Requests

If you've got updates to make this container and/or scripts
run well on OSX or Windows, please make a pull request.

More broadly, Pull Requests welcome!
