defmodule TableizerTest do
  use ExUnit.Case
  import Tableizer

  test "formats a list of maps" do
    output = tableize([
      %{name: "John Barry", age: 27, foo: "bar"},
      %{name: "Mary J Blige", age: 28, foo: "bar"}
    ], [:age, :name])

    assert output == """
    age | name        
    ----+-------------
    27  | John Barry  
    28  | Mary J Blige
    """
  end
end