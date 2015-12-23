defmodule Hello.HelloController do
  use Hello.Web, :controller

  def world(conn, params) do
    %{"name" => name} = params
    render conn, "world.html", name: name, foo: "bar"
  end

  def api(conn, params) do
    json conn, %{hello: "world", age: 10}
  end
end
