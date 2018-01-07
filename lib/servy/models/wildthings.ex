defmodule Servy.Models.Wildthings do
  alias Servy.Models.Bear

  @db_path Path.expand("db", File.cwd!)

  def list_bears do
    {:ok, bears} =
      @db_path
      |> Path.join("bears.json")
      |> File.read 

    Poison.decode!(bears, as: %{"bears" => [%Bear{}]})
    |> Map.get("bears")
  end

  def get_bear(id) when is_integer(id) do
    Enum.find(list_bears(), fn(b) -> b.id == id end)
  end

  def get_bear(id) when is_binary(id) do
    id |> String.to_integer |> get_bear
  end
end