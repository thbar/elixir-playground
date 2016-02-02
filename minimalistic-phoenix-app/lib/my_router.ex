defmodule MyRouter do
  use Phoenix.Router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :api

    get "/", MyController, :index
  end
end
