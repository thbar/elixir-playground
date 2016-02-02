defmodule WebHelloWorld.Endpoint do
  use Phoenix.Endpoint, otp_app: :web_hello_world

  plug WebHelloWorld.Router
end
