This is my implementation of the exercise in chapter 13 of "Programming Elixir".

Note that I'm purposely not following that chapter flow, but rather implement iteratively like I would do in real life.

```
# invoke the CLI parsing manually
mix run -e 'IO.puts Issues.CLI.run(["--help"])'

# run all the tests
mix test

# automatically run tests on file save
mix test.watch
```

## Things I want to check out

- [ ] How to use a "RSpec documentation" type of ExUnit formatter, rather than dots?
