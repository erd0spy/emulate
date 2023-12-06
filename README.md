# Emulate

Emulate is a tool for emulating firmware images using QEMU and Firmadyne. It is currently in alpha and may contain bugs or incomplete features.

## Installation

To install Emulate on your system, follow these steps:

1. Clone the Emulate repository:

    ```bash
    $ git clone https://github.com/erd0spy/emulate.git
    $ cd emulate
    ```

2. Install the necessary dependencies using `setup.sh`:

    ```bash
    $ ./scripts/setup.sh
    ```

This will install all the necessary system packages and software tools required to run Emulate. Emulate has been tested on Ubuntu 20.04 and Ubuntu 22.04, but should work on other Linux distributions as well.

## Usage

To use Emulate, run the `emulate.sh` script with the path to the firmware file you want to emulate as an argument:

```bash
sudo ./emulate.sh ./firmware_file
```

The script will then guide you through the process of setting up and running the QEMU emulation environment.

## License

This script is released under the MIT License. Feel free to use, modify, and distribute it as you see fit. However, please note that the script is provided as-is, and the author assumes no liability for any issues that may arise from its use.

## Contributing

We welcome and encourage contributions to Emulate! If you encounter any bugs or issues with Emulate, or if you would like to contribute to its development, please submit an issue or pull request on the Emulate GitHub repository:  https://github.com/erd0spy/emulate.

## TODO

- Automate Emulate installation and usage with Docker.
- Add support for installation on other Linux distributions.
