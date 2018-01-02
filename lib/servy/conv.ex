defmodule Servy.Conv do
  defstruct method: "", 
            path: "", 
            resp_headers: %{ 
              "Content-Type" => "text/html",
              "Content-Length" => "",
            },
            resp_body: "", 
            params: %{},
            headers: %{},
            status: nil

  def full_status(conv) do
    "#{conv.status} #{status_reason(conv.status)}"
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error",
    }[code]
  end

  def put_resp_content_type(conv, content_type) do
    %{ conv | resp_headers: %{ conv.resp_headers | "Content-Type" => content_type } }
  end

  def put_content_length(conv) do
    %{ conv | resp_headers: %{ conv.resp_headers | "Content-Length" => byte_size(conv.resp_body) } }
  end
end