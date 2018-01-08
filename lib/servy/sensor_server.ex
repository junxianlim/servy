defmodule Servy.SensorServer do

  @name :sensor_server

  use GenServer, restart: :temporary
  alias Servy.Models.VideoCam
  alias Servy.Models.Tracker

  defmodule State do
    defstruct sensor_data: %{}, refresh_interval: :timer.minutes(60), timer_ref: ""
  end

  # def child_spec(args) do
  #   IO.inspect args
  #   %{
  #     id: __MODULE__,
  #     start: {__MODULE__, :start_link, [1]},
  #     restart: :permanent,
  #     shutdown: 5000,
  #     type: :worker
  #   }
  # end

  # Client Interface

  def start_link(interval) do
    IO.puts "Starting the sensor server with #{inspect interval} refresh"
    GenServer.start_link(__MODULE__, %State{ refresh_interval: :timer.minutes(interval)}, name: @name)
  end

  def get_sensor_data do
    GenServer.call @name, :get_sensor_data
  end

  def set_refresh_interval(refresh_interval) do
    GenServer.cast @name, {:set_refresh_interval, refresh_interval}
  end

  # Server Callbacks

  def init(state) do
    sensor_data = run_tasks_to_get_sensor_data()
    initial_state = %State{ state | sensor_data: sensor_data }
    timer_ref = schedule_refresh(initial_state.refresh_interval)
    {:ok, %State{ initial_state | timer_ref: timer_ref }}
  end

  def handle_info(:refresh, state) do
    IO.puts "Refreshing the cache.."
    sensor_data = run_tasks_to_get_sensor_data()
    new_state = %State{ state | sensor_data: sensor_data }
    timer_ref = schedule_refresh(new_state.refresh_interval)
    {:noreply, %State{ new_state | timer_ref: timer_ref }}
  end

  def handle_call(:get_sensor_data, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:set_refresh_interval, refresh_interval}, state) do
    Process.cancel_timer(state.timer_ref)
    timer_ref = schedule_refresh(refresh_interval)
    new_state = %State{ state | refresh_interval: refresh_interval, timer_ref: timer_ref }
    {:noreply, new_state}
  end

  defp schedule_refresh(refresh_interval) do
    Process.send_after(self(), :refresh, refresh_interval)
  end

  defp run_tasks_to_get_sensor_data do
    IO.puts "Running tasks to get sensor data..."

    task = Task.async(fn -> Tracker.get_location("bigfoot") end)

    snapshots =
      ["cam-1", "cam-2", "cam-3"]
      |> Enum.map(&Task.async(fn -> VideoCam.get_snapshot(&1) end))
      |> Enum.map(&Task.await/1)

    where_is_bigfoot = Task.await(task)

    %{snapshots: snapshots, location: where_is_bigfoot}
  end
end