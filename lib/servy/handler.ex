defmodule Servy.Handler do
  @moduledoc "Handles HTTP requests."

  import Servy.Plugins,         only: [rewrite_path: 1, track: 1, put_content_length: 1]
  import Servy.Parser,          only: [parse: 1]
  import Servy.FileHandler,     only: [fetch_file: 2]
  alias  Servy.Conv
  alias  Servy.Controllers.BearController
  alias  Servy.Controllers.SensorsController
  alias  Servy.Controllers.Api.BearController, as: ApiBearController

  @doc "Transforms the request into a response."
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> route
    |> track
    |> put_content_length
    |> format_response
  end

  def route(%Conv{ method: "GET", path: "/sensors" } = conv) do
    SensorsController.index(conv)
  end

  def route(%Conv{ method: "GET", path: "/faq"} = conv) do
    conv = fetch_file("faq.md", conv)
    %Conv{ conv | resp_body: Earmark.as_html!(conv.resp_body) }
  end

  def route(%Conv{ method: "GET", path: "/about" } = conv) do
    fetch_file("about.html", conv)
  end
  
  def route(%Conv{ method: "GET", path: "/api/bears" } = conv) do
    ApiBearController.index(conv)
  end

  def route(%Conv{ method: "POST", path: "/api/bears" } = conv) do
    ApiBearController.create(conv)
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

  def format_response_headers(conv) do
    Enum.map(conv.resp_headers, fn({k,v}) -> 
      "#{k}: #{v}\r"
    end) |> Enum.sort |> Enum.reverse |> Enum.join("\n")
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    #{format_response_headers(conv)}
    \r
    #{conv.resp_body}
    """
  end
end