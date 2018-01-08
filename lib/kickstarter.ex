defmodule Servy.KickStarter do
  use GenServer

  def start do
    IO.puts "Starting the kickstarter.."
    GenServer.start(__MODULE__, :ok, name: __MODULE__)
  end

  def get_server do
    GenServer.call __MODULE__, :get_server
  end

  def init(:ok) do
    server_pid = start_server()
    {:ok, server_pid}
  end

  def handle_call(:get_server, _from, state) do
    {:reply, state, state}
  end

  def handle_info({:EXIT, _pid, reason}, _state) do
    IO.puts "HttPServer exited (#{inspect reason})"
    server_pid = start_server()
    {:noreply, server_pid}
  end

  defp start_server do
    Process.flag(:trap_exit, true)
    IO.puts "Starting the HTTP server..."
    server_pid = spawn_link(Servy.HttpServer, :start, [4000])
    Process.register(server_pid, :http_server)

    server_pid
  end
end