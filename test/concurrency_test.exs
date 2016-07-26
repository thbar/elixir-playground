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
        {:ok, outcome} ->
          # won't be called
        after 10 ->
          raise "Timed out"
      end
    end
  end
end