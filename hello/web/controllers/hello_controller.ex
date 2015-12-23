defmodule Hello.HelloController do
  use Hello.Web, :controller

  def world(conn, params) do
    %{"name" => name} = params
    render conn, "world.html", name: name, foo: "bar"
  end
end
