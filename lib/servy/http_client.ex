defmodule Servy.HttpClient do
  def call do
    request = """
    GET /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    host = 'localhost'
    {:ok, sock}     = :gen_tcp.connect(host, 4000, [:binary, packet: :raw, active: false])
    :ok             = :gen_tcp.send(sock, request)
    {:ok, response} = :gen_tcp.recv(sock, 0)
    :ok             = :gen_tcp.close(sock)

    IO.inspect response
  end
end