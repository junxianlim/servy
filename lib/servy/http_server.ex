defmodule Servy.HttpServer do
  import Servy.Handler, only: [handle: 1]
  
  @doc """
  Starts the server on the given `port` of localhost
  """
  def start(port) when is_integer(port) and port > 1023 do
    
    # Creates a socket to listen for client connections.
    # `lsock` is bound to the listening socket.
    {:ok, lsock} =
      :gen_tcp.listen(port, [:binary, packet: :raw, active: false, reuseaddr: true])
    
    # Socket options (don't worry about these details):
    # `:binary` - open the socket in "binary" mode and deliver data as binaries
    # `packet: :raw` - deliver the entire binary without doing any packet handling
    # `active: false` - receive data when we're ready by calling `:gen_tcp.recv/2`
    # `reuseaddr: true` - allows reusing the address if the listener crashes

    IO.puts "\n🎧  Listening for connection requests on port #{port}...\n"

    accept_loop(lsock)
  end

  @doc """
  Accepts client connections on the 'lsock'.
  """
  def accept_loop(lsock) do
    IO.puts "⌛️  Waiting to accept a client connection...\n"

    # Suspends (blocks) and waits for a client connection. When a connection
    # is accepted, 'csock' is bound to a new client socket.
    {:ok, csock} = :gen_tcp.accept(lsock)
    
    IO.puts "⚡️  Connection accepted!\n"

    # Receives the request and sends a response over the client socket.
    serve(csock)

    # Loop back to wait and accept the next connection.
    accept_loop(lsock)
  end

  @doc """
  Receives the request on the `client_socket` and 
  sends a response back over the same socket.
  """
  def serve(csock) do
    csock
    |> read_request
    |> handle
    |> write_response(csock)
  end

  @doc """
  Receives a request on the client socket.
  """
  def read_request(csock) do
    {:ok, req} = :gen_tcp.recv(csock, 0) # all available types

    IO.puts "➡️  Received request:\n"
    IO.puts req

    req
  end

  @doc """
  Sends the response over the client socket.
  """
  def write_response(res, csock) do
    :ok = :gen_tcp.send(csock, res)

    IO.puts "⬅️  Sent response:\n"
    IO.puts res

    # Closes the client socket, ending the connection.
    # Does not close the listen socket!
    :gen_tcp.close(csock)
  end
end

