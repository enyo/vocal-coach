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

# Install sassc
SASS_PARENT_FOLDER="/home/rof/sass"
SASSC_LINK="/home/rof/bin/sassc"

git clone https://github.com/sass/sassc.git "$SASS_PARENT_FOLDER/sassc" --branch 3.1.0 --depth 1
git clone https://github.com/sass/libsass.git "$SASS_PARENT_FOLDER/libsass" --branch 3.1.0 --depth 1

cd "$SASS_PARENT_FOLDER/sassc"
echo cd "$SASS_PARENT_FOLDER/sassc"
SASS_LIBSASS_PATH="$SASS_PARENT_FOLDER/libsass"; make

ln -s "$SASS_PARENT_FOLDER/sassc/bin/sassc" "$SASSC_LINK"

cd -

# run pub get
pub get
