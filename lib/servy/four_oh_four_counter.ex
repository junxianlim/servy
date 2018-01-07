defmodule Servy.FourOhFourCounter do
  @name :four_oh_four_counter
  use GenServer

  def start do
    GenServer.start(__MODULE__, %{}, name: @name)
  end

  def bump_count(url) do
    GenServer.call @name, { :bump_count, url }
  end

  def get_count(url) do
    GenServer.call @name, { :get_count, url }
  end
  
  def get_counts do
    GenServer.call @name, :get_counts
  end

  def clear_counts do
    GenServer.cast @name, :clear_counts
  end

  # Server callbacks

  def handle_call({:bump_count, url}, _from, state) do
    new_state = add_url_count(state, url)
    {:reply, new_state, new_state}
  end

  def handle_call({:get_count, url}, _from, state) do
    count = Map.get(state, url)
    {:reply, count, state}
  end

  def handle_call(:get_counts, _from, state) do
    {:reply, state, state}
  end

  def handle_cast(:clear_counts, _state) do
    {:noreply, %{}}
  end

  def handle_info(other, state) do
    IO.puts "Can't touch this: #{inspect other}"
    {:noreply, state}
  end

  defp add_url_count(state, url) do
    case Map.get(state, url) do
      nil ->
        Map.put(state, url, 1)
      amount ->
        Map.put(state, url, amount + 1)
    end
  end
end