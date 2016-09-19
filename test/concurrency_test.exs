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
  
  defmodule Chain do
    def counter(next_pid) do
      receive do
        # NOTE: passing the parent PID isn't mandatory here, as it turns out
        n ->
          send(next_pid, n + 1)
      end
    end
    
    def create_processes(n) do
      # a somewhat confusing (to me) way to create a chain - but anyway
      last = Enum.reduce 1..n, self, fn (_, send_to) -> spawn(Chain, :counter, [send_to]) end
      send last, 0
      receive do
        msg ->
          assert msg == n
      end
    end
  end
  
  test "creating many workers isn't too costly" do
    {microsecs,true} = :timer.tc(Chain, :create_processes, [20000])
    assert microsecs < 200_000
  end
  
  defmodule Bouncer do
    def bounce do
      receive do
        {sender, message} -> 
          send(sender, message)
      end
    end
  end

  test "undeterministic message order" do
    fred = spawn(Bouncer, :bounce, [])
    betty = spawn(Bouncer, :bounce, [])
    send(fred, {self, "fred"})
    send(betty, {self, "betty"})
    receive do
      _message ->
        assert 0 == 0 # NO-OP to avoid warning 
        # what you get here will often be fred, but sometimes betty
        # this isn't deterministic
        #IO.puts(message <> "\n\n")
      after 10 -> raise "foo"
    end
  end
  
  defmodule Sayonara do
    import :timer, only: [ sleep: 1]

    def sad_function(delay \\ 250) do
      sleep(delay)
      exit(:sayonara)
    end
  end
  
  test "process dying does not impact main process" do
    spawn(Sayonara, :sad_function, [])
    # NOTE: the :ok is passed back from "after"
    :ok = receive do
      _msg ->
        raise "This will not happen"
      after 300 ->
        :ok
    end
  end
  
  test "process dying can impact main process if we link them" do
    # a test trick to make sure we are informed about the exit
    Process.flag(:trap_exit, true)
    spawn_link(Sayonara, :sad_function, [])
    receive do
      # We're only receiving this because of the trap_exit setup
      # otherwise the process would just crash
      {:EXIT, _pid, exit_message} ->
        assert exit_message == :sayonara
    end
  end
  
  test "monitoring lets a process spawn another without reverse notification" do
    {_pid, _monitoring_reference} = spawn_monitor(Sayonara, :sad_function, [])
    # NOTE: we assert on getting the :down
    :down = receive do
      {:DOWN, _ref, _p, _pid, _method} ->
        :down
      after 1000 ->
        :after
    end
  end
  
  test "calling receive after a process crash will still give us the down message" do
    {_pid, _monitoring_reference} = spawn_monitor(Sayonara, :sad_function, [0.1])
    :timer.sleep(1)
    # NOTE: we assert on getting the :down
    :down = receive do
      {:DOWN, _ref, _p, _pid, _method} ->
        IO.puts "WE still get here"
        :down
      after 1000 ->
        :after
    end
  end
  
  defmodule TheChild do
    def ping(options) do
      if options.raise do
        raise "I'm failing!"
      else
        send(options.parent_pid, "Hello from child (call #{options.call})")
      end
    end
  end
  
  defmodule TheParent do
    def receive_loop(result \\ []) do
      receive do
        message -> 
          receive_loop([message | result])
        after 10 ->
          Enum.reverse(result)
      end
    end
  end
  
  test "WorkingWithMultipleProcesses-3" do
    spawn_link(TheChild, :ping, [%{parent_pid: self, call: 1, raise: false}])
    # We are not waiting inside receive when the messages are sent,
    # yet they will arrive to the parent nonetheless.
    :timer.sleep(250)
    assert [
      "Hello from child (call 1)",
    ] == TheParent.receive_loop
  end
  
  @tag :skip
  test "WorkingWithMultipleProcesses-4" do
    # NOTE: this does not catch the exception, presumably because
    # the main process is killed itself due to spawn_link
    assert_raise RuntimeError, "I'm failing!", fn() ->
      spawn_link(TheChild, :ping, [%{parent_pid: self, call: 1, raise: true}])
    end
  end
  
  test "WorkingWithMultipleProcesses-5" do
    # spawn_monitor won't crash the main process, and will notify a :DOWN message
    spawn_monitor(TheChild, :ping, [%{parent_pid: self, call: 1, raise: true}])
    output = TheParent.receive_loop
    assert 1 = Enum.count(output)
    {:DOWN, _, :process, _, _} = Enum.at(output, 0)
  end
end