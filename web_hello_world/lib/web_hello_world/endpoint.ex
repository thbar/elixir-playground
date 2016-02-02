defmodule WebHelloWorld.Endpoint do
  use Phoenix.Endpoint, otp_app: :web_hello_world

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_web_hello_world_key",
    signing_salt: "dhdyGopT"

  plug WebHelloWorld.Router
end
