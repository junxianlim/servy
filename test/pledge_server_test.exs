defmodule PlegeServerTest do
  use ExUnit.Case, async: true
  alias Servy.PledgeServer
  PledgeServer.start()

  test "it should create a new pledge" do
    PledgeServer.create_pledge("bob", 10)

    assert PledgeServer.recent_pledges() == [{"bob", 10}]
  end

  test "it should return 3 most recent pledges" do
    [{"bob", 15}, {"adam", 30}, {"jason", 50}, {"jessica", 100}]
    |> Enum.map(fn({name,amount}) -> PledgeServer.create_pledge(name, amount) end)

    assert PledgeServer.recent_pledges() == [ {"jessica", 100}, {"jason", 50},{"adam", 30}]
  end
end