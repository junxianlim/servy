defmodule Servy.Controllers.Api.BearController do
  alias Servy.Models.Wildthings
  alias Servy.Conv

  def index(conv) do
    json =
      Wildthings.list_bears()
      |> Poison.encode!
    
    conv = Conv.put_resp_content_type(conv, "application/json")
    %{ conv | status: 200, resp_body: json }
  end

  def create(%Conv{ params: %{ "name" => name, "type" => type } } = conv) do
    %{ conv | status: 201, resp_body: "Created a #{type} bear named #{name}!" }
  end
end