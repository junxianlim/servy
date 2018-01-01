defmodule Servy.Handler do
  @moduledoc "Handles HTTP requests."

  import Servy.Plugins,     only: [rewrite_path: 1, track: 1]
  import Servy.Parser,      only: [parse: 1]
  import Servy.FileHandler, only: [fetch_file: 2]
  alias  Servy.Conv
  alias  Servy.BearController

  @doc "Transforms the request into a response."
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> route
    |> track
    |> format_response
  end

  def route(%Conv{ method: "GET", path: "/about" } = conv) do
    fetch_file("about.html", conv)
  end
  
  def route(%Conv{ method: "GET", path: "/bears" } = conv) do
    BearController.index(conv)
  end
  
  def route(%Conv{ method: "GET", path: "/bears/" <> id } = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end
  
  def route(%Conv{ method: "POST", path: "/bears" } = conv ) do
    BearController.create(conv)
  end

  def route(%Conv{ method: "DELETE", path: "/bears/" <> id } = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.delete(conv, params)
  end

  def route(conv) do
    %Conv{ conv | status: 404, resp_body: "Route not found" }
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    Content-Type: text/html\r
    Content-Length: #{byte_size(conv.resp_body)}\r
    \r
    #{conv.resp_body}
    """
  end
end