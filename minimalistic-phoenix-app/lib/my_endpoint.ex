defmodule MyEndpoint do
  use Phoenix.Endpoint, otp_app: :my_application

  plug MyRouter
end
