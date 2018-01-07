defmodule Servy.Plugins do

  alias Servy.Conv
  alias Servy.FourOhFourCounter

  @doc "Logs 404 request"
  def track(%{ status: 404, path: path } = conv) do
    FourOhFourCounter.bump_count(path)
    conv
  end

  def track(conv), do: conv

  def put_content_length(conv) do
    Conv.put_content_length(conv)
  end

  def rewrite_path(%Conv{ path: "/wildlife" } = conv) do
    %Conv{ conv | path: "/wildthingcd .s" }
  end

  def rewrite_path(%Conv{ path: path} = conv) do
    regex = ~r{\/(?<thing>\w+)?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conv, captures)
  end

  def rewrite_path(conv), do: conv

  def rewrite_path_captures(conv, %{"thing" => thing, "id" => id}) do
    %Conv{ conv | path: "/#{thing}/#{id}" }
  end

  def rewrite_path_captures(conv, nil), do: conv
end
