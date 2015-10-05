#!/bin/bash -e
#
#  Copyright (c) 2014, Facebook, Inc.
#  All rights reserved.
#
#  This source code is licensed under the BSD-style license found in the
#  LICENSE file in the root directory of this source tree. An additional grant
#  of patent rights can be found in the PATENTS file in the same directory.
#

echo
echo This script will install fblualib and all its dependencies.
echo It has been tested on Ubuntu 13.10 and Ubuntu 14.04, Linux x86_64.
echo

set -e
set -x

if [[ $(arch) != 'x86_64' ]]; then
    echo "x86_64 required" >&2
    exit 1
fi

issue=$(cat /etc/issue)



dir=$(mktemp --tmpdir -d fblualib-build.XXXXXX)

echo Working in $dir
echo
cd $dir

echo Installing required packages
echo


echo
echo Cloning repositories
echo
git clone -b v0.35.0  --depth 1 https://github.com/facebook/folly.git
git clone -b v0.24.0  --depth 1 https://github.com/facebook/fbthrift.git
git clone https://github.com/facebook/thpp
git clone https://github.com/facebook/fblualib

echo
echo Building folly
echo

cd $dir/folly/folly
autoreconf -ivf
./configure
make
make install
ldconfig # reload the lib paths after freshly installed folly. fbthrift needs it.

echo
echo Building fbthrift
echo

cd $dir/fbthrift/thrift
autoreconf -ivf
./configure
make
make install

echo
echo 'Installing TH++'
echo

cd $dir/thpp/thpp
./build.sh

echo
echo 'Installing FBLuaLib'
echo

cd $dir/fblualib/fblualib
./build.sh

echo
echo 'All done!'
echo
