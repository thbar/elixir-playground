defmodule AdventOfCode2018.Puzzle04 do
  def match(a, b) do
    length = String.length(a)
    # reversed Jaro distance formula for
    # 1 transposition and length -1 matching characters
    # on two "length" sized strings
    # I added some large epsilon tolerance to make this work :-)
    abs((String.jaro_distance(a, b) * 3 - 2 * (length - 1) / length) - 1.0) < 0.1
  end

  def seq([head | tail]) do
    found = Enum.find(tail, nil, &match(head, &1))
    if found do [head, found] else seq(tail) end
  end
  
  def find(input) do
    input
    |> String.trim_trailing
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> seq
    |> Enum.map(&String.graphemes(&1))
    |> Enum.zip
    |> Enum.filter(fn({a,b}) -> a == b end)
    |> Enum.map(fn({a,_b}) -> a end)
    |> Enum.join
  end
end
