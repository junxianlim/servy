defmodule HttpServerTest do
  use ExUnit.Case, async: true
  alias Servy.HttpServer
  alias Servy.HttpClient

  test "it runs a server and returns correct response" do
    spawn(HttpServer, :start, [4000])
    max_concurrent_requests = 5
    caller = self()

    for _ <- 1..max_concurrent_requests do
      spawn(fn -> 
        {:ok, response} = HTTPoison.get("localhost:4000/faq")
        send(caller, {:ok, response})
      end)
    end

    expected_body = """
    <h1>Frequently Asked Questions</h1>
    <ul>
      <li>
        <p><strong>Have you really seen Bigfoot?</strong></p>
        <p>  Yes! In this <a href=\"https://www.youtube.com/watch?v=v77ijOO8oAk\">totally believable video</a>!</p>
      </li>
      <li>
        <p><strong>No, I mean seen Bigfoot <em>on the refuge</em>?</strong></p>
        <p>  Oh! Not yet, but we’re still looking…</p>
      </li>
      <li>
        <p><strong>Can you just show me some code?</strong></p>
        <p>  Sure! Here’s some Elixir:</p>
      </li>
    </ul>
    <pre><code class=\"elixir\">  [&quot;Bigfoot&quot;, &quot;Yeti&quot;, &quot;Sasquatch&quot;] |&gt; Enum.random()</code></pre>
    """

    for _ <- 1..max_concurrent_requests do
      receive do
        {:ok, response} ->
          assert response.status_code == 200
          assert remove_whitespace(response.body) == remove_whitespace(expected_body)
      end
    end
  end

  defp remove_whitespace(text) do
    String.replace(text, ~r{\s}, "")
  end 
end