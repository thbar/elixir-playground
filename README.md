Spoiler ahead! In this repository's `koans/koans_test.exs`, I'm storing my own solutions to the exercises found in [Programming Elixir](https://pragprog.com/book/elixir12/programming-elixir-1-2).

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
```

## Creating a minimalistic phoenix app

```
mix phoenix.new web_hello_world --no-brunch
mix deps.get
```

(then truncate loads of stuff)
