# Wingpanel Weather Indicator

## Building and Installation

It's recommended to create a clean build environment

    mkdir build
    cd build/

Run `cmake` to configure the build environment and then `make` to build

    cmake -DCMAKE_INSTALL_PREFIX=/usr ..
    make

To install, use `make install`

    sudo make install
    
Get secret key from [darksky.net](https://darksky.net/dev/account) and store it in your config file.

    cat ~/.weather.config
    {
        "key":"XXXXXXXXXXXXXXXXXXXX"
    }
