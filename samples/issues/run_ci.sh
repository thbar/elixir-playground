#!/usr/bin/env bash
set -e

# TODO: check out TRAVIS env var to only force on Travis so I can use it locally
mix local.hex --force
mix local.rebar --force
mix deps.get

mix test

mix escript.build
./issues --help

if [ "$CI" == "" ]; then
  mix credo list
  mix dogma
fi