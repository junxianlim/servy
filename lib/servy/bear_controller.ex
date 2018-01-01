defmodule Servy.BearController do
  alias Servy.Conv
  alias Servy.Bear
  alias Servy.Wildthings 
  alias Servy.BearView

  def index(conv) do
    bears = 
      Wildthings.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2)
    %Conv{ conv | status: 200, resp_body: BearView.index(bears) }
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    %Conv{ conv | status: 200, resp_body: BearView.show(bear) }
  end

  def create(%Conv{ params: %{"name" => name, "type" => type } } = conv) do
    %Conv{ conv | status: 201, resp_body: "Created a #{type} bear named #{name}"}
  end

  def delete(conv, %{"id" => id}) do
    %Conv{ conv | status: 403, resp_body: "You're forbidden from deleting bear #{id}."}
  end
end