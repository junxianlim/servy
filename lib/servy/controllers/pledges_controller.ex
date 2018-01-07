defmodule Servy.Controllers.PledgesController do

  alias Servy.Conv
  alias Servy.PledgeServer
  alias Servy.Views.PledgesView

  def index(conv) do
    pledges = PledgeServer.recent_pledges()
    %Conv{ conv | status: 200, resp_body: PledgesView.index(pledges) }
  end

  def new(conv) do
    %Conv{ conv | status: 200, resp_body: PledgesView.new() }
  end

  def create(%Conv{ params: %{ "name" => name, "amount" => amount}} = conv) do
    PledgeServer.create_pledge(name, String.to_integer(amount))
    %Conv{ conv | status: 201, resp_body: "#{name} pledged #{amount}"}
  end
end