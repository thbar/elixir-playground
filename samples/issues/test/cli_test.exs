defmodule CLITest do
  use ExUnit.Case

  test "parse_args returns :help when passing --help" do
    import Issues.CLI

    assert run(["--help"]) == :help
  end
end
