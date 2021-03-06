Spoiler ahead! In this repository's `koans/koans_test.exs`, I'm storing my own solutions to the exercises found in [Programming Elixir](https://pragprog.com/book/elixir12/programming-elixir-1-2).

[![Build Status](https://travis-ci.org/thbar/elixir-playground.svg?branch=master)](https://travis-ci.org/thbar/elixir-playground)

## Common tasks

```
# install dependencies
mix deps.get

# clean dependencies
mix deps.clean --all

# check code quality
mix dogma

# run tests
elixir *_test.exs

# launch interactive session with mix setup
iex -S mix

# launch phoenix with iex session
iex -S mix phoenix.server

# visually inspect applications from iex
:observer.start()

# run one function
mix run -e "Issues.CLI.process(:help)"
```

## Creating a minimalistic phoenix app

```
mix phoenix.new web_hello_world --no-brunch
mix deps.get
```

(then truncate loads of stuff)

## Useful resources

* [Elixir CheatSheet](https://media.pragprog.com/titles/elixir/ElixirCheat.pdf)
* [Awesome Elixir](https://github.com/h4cc/awesome-elixir)
