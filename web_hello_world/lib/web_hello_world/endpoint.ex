defmodule WebHelloWorld.Endpoint do
  use Phoenix.Endpoint, otp_app: :web_hello_world

  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug WebHelloWorld.Router
end
