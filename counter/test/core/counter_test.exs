defmodule CounterCoreTest do
  use ExUnit.Case
  doctest Counter.Core

  test "greets the world" do
    assert Counter.Core.inc(2) == 3
  end
end
