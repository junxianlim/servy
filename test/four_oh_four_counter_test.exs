defmodule FourOhFourCounterTest do
  use ExUnit.Case

  alias Servy.FourOhFourCounter, as: Counter

  test "reports counts missing path requests" do
    {:ok, pid} = Counter.start()

    Counter.bump_count("/bigfoot")
    Counter.bump_count("/nessie")
    Counter.bump_count("/nessie")
    Counter.bump_count("/bigfoot")
    Counter.bump_count("/nessie")

    assert Counter.get_count("/nessie") == 3
    assert Counter.get_count("/bigfoot") == 2

    assert Counter.get_counts == %{"/bigfoot" => 2, "/nessie" => 3}

    Process.exit(pid, :kill)
  end

  test "clears counts" do
    {:ok, pid} = Counter.start()

    Counter.bump_count("/bigfoot")
    Counter.bump_count("/nessie")
    Counter.bump_count("/nessie")
    Counter.bump_count("/bigfoot")
    Counter.bump_count("/nessie")

    Counter.clear_counts()

    assert Counter.get_counts == %{}

    Process.exit(pid, :kill)
  end
end