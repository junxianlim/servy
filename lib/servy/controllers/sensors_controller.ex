defmodule Servy.Controllers.SensorsController do
  alias Servy.Conv
  alias Servy.Views.SensorsView
  alias Servy.SensorServer

  def index(conv) do
    %{location: location, snapshots: snapshots} = SensorServer.get_sensor_data()
    %Conv{ conv | resp_body: SensorsView.index(snapshots, location) }
  end
end