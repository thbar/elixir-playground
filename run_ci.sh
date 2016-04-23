#!/usr/bin/env bash
set -e

# run top-level tests
mix local.hex --force
mix deps.get
mix test

for d in samples/*; do
    echo "***** Building $d *****"
    cd "$d"
    ./run_ci.sh
    cd $OLDPWD
done
