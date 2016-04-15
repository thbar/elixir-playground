defmodule TableizerTest do
  use ExUnit.Case
  import Tableizer

  test "formats a list of maps" do
    output = tableize([
      %{name: "John Barry", zage: 27, foo: "bar"},
      %{name: "Mary J Blige", zage: 28, foo: "bar"}
    ], [:zage, :name])
    
    assert output == """
    zage | name        
    -----+-------------
    27   | John Barry  
    28   | Mary J Blige
    """
  end
end