defmodule HackAssembler.SymbolTable do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def add_var(name) do
    GenServer.call(__MODULE__, {:add_var, name})
  end

  def add_label(name, address) do
    GenServer.call(__MODULE__, {:add_label, name, address})
  end

  def contains?(name) do
    GenServer.call(__MODULE__, {:contains?, name})
  end

  def get_address(name) do
    GenServer.call(__MODULE__, {:get_address, name})
  end

  def get_table() do
    GenServer.call(__MODULE__, :get_table)
  end

  @impl true
  def init(_) do
    state = %{n: 16, s_table: initialize_s_table()}
    {:ok, state}
  end

  @impl true
  def handle_call({:add_var, name}, _from, %{n: n, s_table: s_table} = state) do
    updated_state = %{
      state
      | s_table: Map.put(s_table, name, Integer.to_string(n)),
        n: n + 1
    }

    {:reply, :ok, updated_state}
  end

  @impl true
  def handle_call({:add_label, name, address}, _from, %{s_table: s_table} = state) do
    updated_state = %{state | s_table: Map.put(s_table, name, address)}

    {:reply, :ok, updated_state}
  end

  @impl true
  def handle_call({:contains?, name}, _from, %{s_table: s_table} = state) do
    contains? = Map.has_key?(s_table, name)

    {:reply, contains?, state}
  end

  @impl true
  def handle_call({:get_address, name}, _from, %{s_table: s_table} = state) do
    address = Map.get(s_table, name)
    {:reply, address, state}
  end

  @impl true
  def handle_call(:get_table, _from, state) do
    {:reply, state, state}
  end

  defp initialize_s_table() do
    Enum.reduce(0..15, %{}, fn n, table ->
      Map.put(table, "R#{n}", Integer.to_string(n))
    end)
    |> Map.put("SCREEN", "16384")
    |> Map.put("KBD", "24576")
    |> Map.put("SP", "0")
    |> Map.put("LCL", "1")
    |> Map.put("ARG", "2")
    |> Map.put("THIS", "3")
    |> Map.put("THAT", "4")
  end
end
