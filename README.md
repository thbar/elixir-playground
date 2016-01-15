Spoiler ahead! In this repository's `koans/koans_test.exs`, I'm storing my own solutions to the exercises found in [Programming Elixir](https://pragprog.com/book/elixir12/programming-elixir-1-2).

The rest is random tests.

# Installing phoenix

```
mix archive.install https://github.com/phoenixframework/phoenix/releases/download/v1.1.0/phoenix_new-1.1.0.ez
mix phoenix.new hello
```

Replace? (yes?)

# Tring out elements from console

```
iex -S mix
Phoenix.View.render(Hello.HelloView, "world.html", %{})
```
