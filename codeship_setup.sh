#!/usr/bin/env bash

# Abort on error
set -e

# Change to directory of this script
ROOT_DIR=`dirname $0`

# dart version can also be 'latest'
DART_VERSION='1.13.2'


# Get the latest dart sdk
wget https://storage.googleapis.com/dart-archive/channels/stable/release/${DART_VERSION}/sdk/dartsdk-linux-x64-release.zip
unzip -o dartsdk-linux-x64-release.zip -d ~

curl -sSL https://gist.githubusercontent.com/enyo/3130934c282257f8e6b4/raw/3499a0670f7d18dc8278400cbb4ce47f46b39b1c/phantomjs2.sh | bash -s

# run pub get
pub get
