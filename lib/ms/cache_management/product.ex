defmodule Ms.CacheManagement.Product do
  @moduledoc """
    Caches our product data, based on substring index
  """

  use GenServer

  # Starts a GenServer process running this module
  def start_link(_opts) do
    # This name will be used to send message in GenServer.cast and GenServer.call
    GenServer.start_link(__MODULE__, %{}, name: Product)
  end

  # This function will be executed when a GenServer is spawned and output of this function becomes the state of the Genserver.
  def init(state) do
    # Notice the :ets and not ets, it is because we are directly calling into erlang
    :ets.new(:inventory_cache, [:set, :public, :named_table])
    {:ok, state}
  end

  def delete(key) do
    # GenServer.cast is asynchronous on client side, while GenServer.call is Synchronous(blocking)
    GenServer.call(Product, {:delete, key})
  end

  def clean_cache() do
    GenServer.call(Product, {:clean})
  end

  # Notice that here we don't use GenServer.
  # If we use GenServer, all reads will end up being a Serial operation, as GenServer executes serially
  # ETS allows concurrent reads, so we directly query the ETS and all other operations like put and delete
  # goes through GenServer, serializing it.
  def get(key) do
    case :ets.lookup(:inventory_cache, key) do
      [] -> []
      [{_key, product}] -> product
    end
  end

  # Notice that we use GenServer.call even if we don't take return value.
  # This is required because GenServer.cast is asynchronous and hence is not strict
  # If we use cast, we can't guarantee that put will have put the value in ets, when it returns.
  def put(key, value) do
    # We use cast when we don't care about the result
    GenServer.call(Product, {:put, key, value})
  end

  # All GenServer.cast calls ends up calling handle_cast
  def handle_call({:delete, key}, _from, state) do
    :ets.delete(:inventory_cache, key)
    # Since we don't care about result, we reply with :ok
    {:reply, :ok, state}
  end

  def handle_call({:put, key, data}, _from, state) do
    :ets.insert(:inventory_cache, {key, data})
    {:reply, :ok, state}
  end

  def handle_call({:clean}, _from, state) do
    :ets.delete_all_objects(:inventory_cache)
    {:reply, :ok, state}
  end

  # All GenServer.call calls ends up calling handle_call
  # If we don't have this handling, which collects all messages, we can have a memory leak as elixir
  # doesn't throw away unmatched/unhandled message. Here using this handler we just throw them away.
  def handle_call(_msg, _from, state) do
    {:reply, :ok, state}
  end
end
