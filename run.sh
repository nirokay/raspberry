#!/bin/bash

# Import resources:
# shellcheck disable=SC1090
source ~/raspberry/resources.conf.sh

# Run file:
cd "$RASPBERRY_FILES" || cd ~/raspberry/ || echo "Uh oh, directory not found..."
$STARTUP_FILE
