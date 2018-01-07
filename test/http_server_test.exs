defmodule HttpServerTest do
  use ExUnit.Case, async: true
  alias Servy.HttpServer

  test "it runs a server and returns correct response" do
    spawn(HttpServer, :start, [4000])

    ["localhost:4000/faq", "localhost:4000/bears"]
    |> Enum.map(&Task.async(HTTPoison, :get, [&1]))
    |> Enum.map(&Task.await/1)
    |> Enum.map(&assert_success_response/1)
  end

  defp assert_success_response({:ok, response}) do
    assert response.status_code == 200
  end
end