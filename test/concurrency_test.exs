defmodule ConcurrencyTest do
  use ExUnit.Case, async: true
  
  defmodule Computator do
    def double do
      receive do
        {sender, msg} ->
          send sender, { :ok, 2 * msg }
      end
    end
  end
  
  # @tag :focus
  test "spawns a process that passes back a message" do
    # run it in a separate process
    pid = spawn(Computator, :double, [])
    # send a message with the number we want to double
    send pid, {self, 10}
    # wait for the spawned process to send something back to us
    receive do
      {:ok, outcome} ->
        assert 20 == outcome
    end
  end
  
  test "times out on message reception" do
    assert_raise RuntimeError, "Timed out", fn ->
      receive do
        after 10 ->
          raise "Timed out"
      end
    end
  end
  
  defmodule RecursiveAdder do
    # elixir doesn't have loops - use recursion
    def add(value \\ 0) do
      receive do
        { _sender, :done} ->
          # TODO: figure out how to avoid the warning without putting something here
          "nothing"
        { sender, number } ->
          value = value + number
          send sender, { :ok, value }
          add(value)
      end
    end
  end

  test "recursive receive" do
    pid = spawn(RecursiveAdder, :add, [100])
    send(pid, {self, 10})
    send(pid, {self, 10})
    send(pid, {self, :done})
    receive do
      {:ok, new_sum} -> assert 110 == new_sum
    end
    receive do
      {:ok, new_sum} -> assert 120 == new_sum
    end
    # no need to kill here
  end
end