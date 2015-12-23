defmodule Hello.HelloView do
  use Hello.Web, :view

  def message do
    "Hello from the view! It's #{1+2}"
  end
end
