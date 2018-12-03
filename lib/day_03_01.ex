defmodule AdventOfCode2018.Day0301 do
  @regexp ~r/^#(?<id>\d+) @ (?<x>\d+),(?<y>\d+): (?<w>\d+)x(?<h>\d+)$/
  
  @doc ~S"""
  iex> AdventOfCode2018.Day0301.interpret("#1 @ 1,3: 4x4")
  %{id: 1, x: 1, y: 3, w: 4, h: 4}
  iex> AdventOfCode2018.Day0301.interpret("#123 @ 2,10: 6x7")
  %{id: 123, x: 2, y: 10, w: 6, h: 7}
  """
  def interpret(input) do
    data = Regex.named_captures(@regexp, input)

    keys = Map.keys(data)
    |> Enum.map(&String.to_atom(&1))

    values = Map.values(data)
    |> Enum.map(&String.to_integer(&1))

    Map.new(Enum.zip(keys, values))
  end
  
  # We store all the "pixels" in a map to count them later
  def mark(box=%{x: x, y: y, w: w, h: h}, map) do
    places = for i <- (0..w-1) do
      for j <- (0..h-1) do
        %{x: x + i, y: y + j}
      end
    end

    places
    |> List.flatten
    |> Enum.reduce(map, fn(p, acc) -> 
      {_, m} = Map.get_and_update(acc, p, &({&1, (&1 || 0) + 1}))
      m
    end)
  end

  # Input is analysed line by line, then we build a map of all the pixels
  # drawn by each box, and finally we count all the pixels drawn more than once.
  def count_overlap(input) do
    data = input
    |> String.splitter("\n", trim: true)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&(interpret(&1)))
    |> Enum.map(&(&1))
    |> Enum.reduce(Map.new, fn(p, acc) -> 
      mark(p, acc)
    end)
    |> Enum.reduce(0, fn({_, count}, acc) ->
      if count > 1 do acc + 1 else acc end
    end)
  end
end