defmodule CLITest do
  use ExUnit.Case

  test "parse_args returns :help when passing --help" do
    # NOTE: this syntax works inside a do block apparently
    import Issues.CLI, only: [ parse_args: 1]

    assert parse_args(["--help"]) == :help
  end
end
