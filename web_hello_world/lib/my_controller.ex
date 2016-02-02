defmodule MyController do
  use Phoenix.Controller

  def index(conn, _params) do
    json conn, %{hello: "world"}
  end
end
