#!/usr/bin/env bash

cd `dirname $0`/../..

pub run test -p content-shell

cd -