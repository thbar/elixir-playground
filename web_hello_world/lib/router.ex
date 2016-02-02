defmodule WebHelloWorld.Router do
  use Phoenix.Router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WebHelloWorld do
    pipe_through :api

    get "/", PageController, :index
  end
end
