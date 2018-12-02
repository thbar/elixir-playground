defmodule AdventOfCode2018.Puzzle02 do
  def compute(input) do
    data = input
    |> String.graphemes
    |> Enum.group_by(&(&1))
    |> Map.values
    |> Enum.map(&(Enum.count(&1)))

    {
      Enum.member?(data, 2),
      Enum.member?(data, 3)
    }
  end
  
  def solve(input) do
    {a, b} = input
    |> String.trim_trailing
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&compute(&1))
    |> Enum.reduce({0, 0}, fn({two_count, three_count}, {two_total, three_total}) -> 
      two_total = if two_count do two_total + 1 else two_total end
      three_total = if three_count do three_total + 1 else three_total end
      {two_total, three_total}
    end)
    
    a * b
  end
end
