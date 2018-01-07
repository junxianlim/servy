defmodule Servy.Controllers.SensorsController do
  alias Servy.Conv
  alias Servy.Views.SensorsView
  alias Servy.Models.Tracker
  alias Servy.Models.VideoCam
  
  def index(conv) do
    bigfoot_location_task = Task.async(Tracker, :get_location, ["bigfoot"])
    snapshots = 
      ["cam-1", "cam-2", "cam-3"]
      |> Enum.map(&Task.async(VideoCam, :get_snapshot, [&1]))
      |> Enum.map(&Task.await/1)
    
    location = Task.await(bigfoot_location_task)

    %Conv{ conv | resp_body: SensorsView.index(snapshots, location) }
  end
end