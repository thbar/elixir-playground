# allows standalone run
Code.require_file "test/test_helper.exs"

defmodule OTPTest do
  use ExUnit.Case, async: true
  
  # inspiration http://culttt.com/2016/08/24/understanding-genserver-elixir/
  defmodule Storage do
    use GenServer
    
    # convenience method to start the module as a genserver
    def start_link do
      GenServer.start_link(__MODULE__, :ok, [])
    end
    
    # public API for client to work with
    def read(pid) do
      GenServer.call(pid, {:read})
    end
    
    def write(pid, item) do
      GenServer.call(pid, {:write, item})
    end
    
    # genserver callbacks
    def init(:ok) do
      {:ok, []}
    end
    
    # The return value of a handle_call/3 function 
    # should be a tuple where the first argument is 
    # the atom :reply, the second argument is the value 
    # to be returned to the client, and the third 
    # argument should be the state.
    def handle_call({:read}, _from, state) do
      {:reply, state, state}
    end
    
    def handle_call({:write, item}, _from, state) do
      {:reply, item, state ++ [item]}
    end
  end
  
  test "stores state in a GenServer" do
    {:ok, pid} = Storage.start_link
    
    Storage.write(pid, "hello")
    Storage.write(pid, "world")
    
    assert ["hello", "world"] == Storage.read(pid)
  end
end