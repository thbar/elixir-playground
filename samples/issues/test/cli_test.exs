defmodule CLITest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [ parse_args: 1 ]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
  end
  
  test "three values returned if three given" do
    assert parse_args(["user", "project", "16"]) == {"user", "project", 16}
  end
  
  test "count is defaulted if two values given" do
    assert parse_args(["user", "project"]) == {"user", "project", 4}
  end
end
