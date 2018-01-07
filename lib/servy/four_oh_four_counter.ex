defmodule Servy.FourOhFourCounter do
  @name :four_oh_four_counter

  def start do
    pid = spawn(__MODULE__, :listen_loop, [%{}])
    Process.register(pid, @name)
    pid
  end

  def bump_count(url) do
    send @name, { self(), :bump_count, url }
    receive do {:response, message} -> message end
  end

  def get_count(url) do
    send @name, { self(), :get_count, url }
    receive do {:response, count } -> count end
  end
  
  def get_counts do
    send @name, { self(), :get_counts }
    receive do {:response, counts } -> counts end
  end

  def listen_loop(state) do
    receive do
      {sender, :bump_count, url } ->
        new_state = add_url_count(state, url)
        send sender, {:response, "Added new count!"}
        listen_loop(new_state)
      {sender, :get_count, url } ->
        count = Map.get(state, url)
        send sender, {:response, count}
        listen_loop(state)
      {sender, :get_counts} ->
        send sender, {:response, state}
        listen_loop(state)
      unexpected ->
        IO.puts "Unexpected message: #{inspect unexpected}"
        listen_loop(state)
    end
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