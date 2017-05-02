defmodule HelloNerves.Store do

  require Logger

  @defaults %{
    blink_ms: 1000
  }

  def start_link do
    Logger.debug "Initializing store"
    Agent.start_link(fn -> @defaults end, name: __MODULE__)
  end

  def get(key) do
    Agent.get(__MODULE__, &Map.get(&1, key))
  end

  def put(key, value) do
    Agent.update(__MODULE__, &Map.put(&1, key, value))
  end
end
