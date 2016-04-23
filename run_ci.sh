#!/usr/bin/env bash
set -e

# run top-level tests
mix local.hex --force
mix deps.get
mix test

# run samples tests
cd samples/issues
./run_ci.sh
cd $OLDPWD