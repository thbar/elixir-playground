defmodule AdventOfCode2018.Puzzle02 do
  def count_letters(input) do
    input
    |> String.graphemes
    |> Enum.group_by(&(&1))
    |> Map.values
    |> Enum.map(&(Enum.count(&1)))
  end
  
  def solve(input) do
    {a, b} = input
    |> String.trim_trailing
    |> String.split("\n")
    |> Enum.map(&String.trim(&1))
    |> Enum.reduce({0, 0}, fn(input, {a, b}) ->
      letters_count = count_letters(input)
      {
        a + if Enum.member?(letters_count, 2) do 1 else 0 end,
        b + if Enum.member?(letters_count, 3) do 1 else 0 end
      }
    end)
    a * b
  end
end
