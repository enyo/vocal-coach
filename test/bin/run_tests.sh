#!/usr/bin/env bash

cd `dirname $0`/../..

echo
if hash content_shell 2>/dev/null; then
  echo "Running headless browser tests with content_shell..."
  pub run test -r expanded -p content-shell
else
  if hash phantomjs 2>/dev/null; then
    echo "Running headless browser tests with phantomjs..."
    pub run test -r expanded -p phantomjs
  else
    echo
    echo "You need to either have content_shell or phantomjs installed and in your path!"
    echo
    exit 1
  fi
fi

cd -