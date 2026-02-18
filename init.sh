#!/bin/sh

# This init script is used to automatically configure the Stata license on service startup
# Expected parameters : None
# This script will decode the STATA_LIC_BASE64 environment variable and write it to the appropriate location

# Run the statalic.sh script that handles license configuration
if [ -f /usr/local/stata/statalic.sh ]; then
    echo "Configuring Stata license automatically..."
    if /usr/local/stata/statalic.sh; then
        echo "Stata license configured successfully!"
    else
        echo "Warning: Failed to configure Stata license. Make sure STATA_LIC_BASE64 is set in your Onyxia secrets."
    fi
else
    echo "Warning: statalic.sh not found at /usr/local/stata/statalic.sh"
fi
