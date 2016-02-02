defmodule WebHelloWorld.PageController do
  use WebHelloWorld.Web, :controller

  def index(conn, _params) do
    json conn, %{hello: "world"}
  end
end
