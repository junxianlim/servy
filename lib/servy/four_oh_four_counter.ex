defmodule Servy.FourOhFourCounter do
  @name :four_oh_four_counter
  alias Servy.GenericServer

  def start do
    GenericServer.start(__MODULE__, @name, %{})
  end

  def bump_count(url) do
    GenericServer.call @name, { :bump_count, url }
  end

  def get_count(url) do
    GenericServer.call @name, { :get_count, url }
  end
  
  def get_counts do
    GenericServer.call @name, :get_counts
  end

  def clear_counts do
    GenericServer.cast @name, :clear_counts
  end

  # Server callbacks

  def handle_call({:bump_count, url}, state) do
    new_state = add_url_count(state, url)
    {new_state, new_state}
  end

  def handle_call({:get_count, url}, state) do
    count = Map.get(state, url)
    {count, state}
  end

  def handle_call(:get_counts, state) do
    {state, state}
  end

  def handle_cast(:clear_counts, _state) do
    %{}
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