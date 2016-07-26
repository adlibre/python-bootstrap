#!/usr/bin/env bash

#
# Python Virtualenv Bootstrap Script
#
# Creates a named virtualenv and optionally installs specified packages with pip. This should
# run anywhere as long as bash/python/curl/tar are installed.
#
# Andrew Cutler - Adlibre Pty Ltd 2013 - 2016
#
# Inspired by http://stackoverflow.com/questions/4324558/whats-the-proper-way-to-install-pip-virtualenv-and-distribute-for-python 

#
# Config: These can be overriden via EXPORT
#

ENV_VERSION=${ENV_VERSION-15.0.2}  # Version of virtualenv
ENV_NAME=$1  # Name of environment
ENV_OPTS=${ENV_OPTS-'--no-site-packages --distribute'}
PYTHON_BINARY=${PYTHON_BINARY-$(which python)}  # Python interpreter to use
URL_BASE=https://pypi.python.org/packages/source/v/virtualenv   # URL to virtualenv package source 

set -e  # Trap errors

#
# Functions
#

function showUsage() {
    echo "Usage: bootstrap.sh <environment-name> <package1> ... <packagex>" 
    exit 0
}

function main() {

    # Check not already existing
    if [ -d $ENV_NAME ]; then
        echo "Environment $ENV_NAME already exists."
        exit 128
    fi 

    # Test for python
    if [ -d $PYTHON_BINARY ]; then
        echo "Python interpreter not found."
        exit 128
    fi

    # Fetch virtualenv
    curl --silent -O $URL_BASE/virtualenv-$ENV_VERSION.tar.gz
    tar -xzf virtualenv-$ENV_VERSION.tar.gz

    # Create the first "bootstrap" environment.
    $PYTHON_BINARY virtualenv-$ENV_VERSION/virtualenv.py -q $ENV_OPTS $ENV_NAME

    # Install additional packages into the environment
    for package in $@; do
        echo "Installing $package in $ENV_NAME."
        $ENV_NAME/bin/pip install -q ${package}
    done

    # Remove downloaded source
    rm -rf virtualenv-$ENV_VERSION && rm -f virtualenv-$ENV_VERSION.tar.gz

    # Finished
    echo ""
    echo "Virtualenv $ENV_NAME created."
    echo ""
    echo "Run"
    echo "   $ source $ENV_NAME/bin/activate && cd $ENV_NAME"
    echo "to enter the virtual environment and"
    echo "   $ deactivate"
    echo "to exit the environment."
}

# Check ENV_NAME set
if [ -z "$ENV_NAME" ]; then
    echo "Error: environment-name not set."
    showUsage
else
    shift
    main $@
fi
