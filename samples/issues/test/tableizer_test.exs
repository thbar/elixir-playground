defmodule TableizerTest do
  use ExUnit.Case
  import Tableizer

  test "convert a list of maps and a list of field names to an array" do
    output = convert_to_array([
      %{name: "John Barry", zage: 27, foo: "bar"},
      %{name: "Mary J Blige", zage: 28, foo: "bar"}
    ], [:zage, :name])
    
    assert output == [
      [:zage, :name],
      [27, "John Barry"],
      [28, "Mary J Blige"]
    ]
  end
  
  test "converts everything to strings" do
    output = stringify([[:this, :that],[50, "test"]])
    
    assert output == [
      ["this", "that"],
      ["50","test"]
    ]
  end
  
  test "computes max width per column" do
    output = stringify([
      [:foobar, :foo, :bar],
      [1, 4, "foobar"]
    ]) |> compute_max_width
    
    assert output == [ 6, 3, 6 ]
  end
  
  test "formats a list of maps" do
    output = convert_to_array([
      %{name: "John Barry", zage: 27, foo: "bar"},
      %{name: "Mary J Blige", zage: 28, foo: "bar"}
    ], [:zage, :name]) |> stringify |> tableize
    
    assert output == """
    zage | name        
    -----+-------------
    27   | John Barry  
    28   | Mary J Blige
    """
  end
end