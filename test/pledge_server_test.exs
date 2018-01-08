defmodule PlegeServerTest do
  use ExUnit.Case, async: true
  alias Servy.PledgeServer
  
  test "it should create a new pledge" do
    {:ok, pid} = PledgeServer.start_link([])
    
    PledgeServer.create_pledge("bob", 10)
    
    assert PledgeServer.recent_pledges() == [{"bob", 10}, {"wilma", 15}, {"fred", 25}]

    Process.exit(pid, :kill)
  end

  test "it should return 3 most recent pledges" do
    {:ok, pid} = PledgeServer.start_link([])
    
    [{"bob", 15}, {"adam", 30}, {"jason", 50}, {"jessica", 100}]
    |> Enum.map(fn({name,amount}) -> PledgeServer.create_pledge(name, amount) end)
    
    assert PledgeServer.recent_pledges() == [ {"jessica", 100}, {"jason", 50},{"adam", 30}]
    
    Process.exit(pid, :kill)
  end

  test "it should set new cache size" do
    {:ok, pid} = PledgeServer.start_link([])

    PledgeServer.set_cache_size(5)

    1..5 |> Enum.map(&PledgeServer.create_pledge("bob#{&1}", &1))

    assert Enum.count(PledgeServer.recent_pledges()) == 5
    Process.exit(pid, :kill)
  end

  test "it should clear cache" do
    {:ok, pid} = PledgeServer.start_link([])

    assert Enum.count(PledgeServer.recent_pledges()) == 2
    PledgeServer.clear()

    assert Enum.count(PledgeServer.recent_pledges()) == 0
    Process.exit(pid, :kill)
  end
end