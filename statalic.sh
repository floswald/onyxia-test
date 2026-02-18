#!/bin/bash

# Decrypt the Stata license from environment variable

if [[ -z "$STATA_LIC_BASE64" ]]; then
    echo "Error: STATA_LIC_BASE64 environment variable is not set."
    exit 1
fi

echo "$STATA_LIC_BASE64" | base64 -d > /usr/local/stata/stata.lic
