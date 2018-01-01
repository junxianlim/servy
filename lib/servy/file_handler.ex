defmodule Servy.FileHandler do

  alias Servy.Conv

  @pages_path Path.expand("pages", File.cwd!)

  def fetch_file(filename, conv) do
    @pages_path
    |> Path.join(filename)
    |> File.read
    |> handle_file(conv)
  end

  def handle_file({:ok, content}, conv) do
    %Conv{ conv | status: 200, resp_body: content }
  end

  def handle_file({:error, :enoent}, conv) do
    %Conv{ conv | status: 404, resp_body: "File not found" }
  end

  def handle_file({:error, reason}, conv) do
    %Conv{ conv | status: 500, resp_body: reason }
  end
end
