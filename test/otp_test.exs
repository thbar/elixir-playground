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
  
  defmodule Cache do
    use GenServer
    
    @name Cache
    
    def start_link(opts \\ []) do
      GenServer.start_link(__MODULE__, %{}, opts ++ [name: @name])
    end
    
    def write(key, value) do
      GenServer.cast(@name, {:write, key, value})
    end
    
    def read(key) do
      GenServer.call(@name, {:read, key})
    end
    
    def delete(key) do
      GenServer.call(@name, {:delete, key})
    end
    
    def exist?(key) do
      GenServer.call(@name, {:exist?, key})
    end
    
    def clear do
      GenServer.cast(@name, {:clear})
    end
    
    def handle_call({:read, key}, _from, state) do
      {:reply, Map.get(state, key), state}
    end
    
    def handle_call({:delete, key}, _from, state) do
      {:reply, Map.get(state, key), Map.delete(state, key)}
    end
    
    def handle_call({:exist?, key}, _from, state) do
      {:reply, Map.has_key?(state, key), state}
    end

    def handle_cast({:write, key, value}, state) do
      {:noreply, Map.put(state, key, value)}
    end
    
    def handle_cast({:clear}, _state) do
      {:noreply, %{}}
    end
  end
  
  test "cache server" do
    Cache.start_link

    Cache.write(:stooges, ["Larry", "Curly", "Moe"])
    assert ["Larry", "Curly", "Moe"] == Cache.read(:stooges)

    assert true = Cache.exist?(:stooges)

    assert ["Larry", "Curly", "Moe"] == Cache.delete(:stooges)
    assert nil == Cache.read(:stooges)
    assert false == Cache.exist?(:stooges)

    Cache.write(:stooges, ["Larry", "Curly", "Moe"])
    assert ["Larry", "Curly", "Moe"] == Cache.read(:stooges)
    Cache.clear
    assert nil == Cache.read(:stooges)
    assert false == Cache.exist?(:stooges)
  end
end