#!/usr/bin/env bash

# TODO: rely on convention so that I can automatically infer all subfolders tests configuration

# run top-level tests
mix deps.get
mix test

# run samples tests
cd samples/issues
mix deps.get
mix test