defmodule AdventOfCode2018.Day0301 do
  @regexp ~r/^#(?<id>\d+) @ (?<x>\d+),(?<y>\d+): (?<w>\d+)x(?<h>\d+)$/
  
  @doc ~S"""
  iex> AdventOfCode2018.Day0301.interpret("#1 @ 1,3: 4x4")
  %{id: 1, x: 1, y: 3, w: 4, h: 4}
  iex> AdventOfCode2018.Day0301.interpret("#123 @ 2,10: 6x7")
  %{id: 123, x: 2, y: 10, w: 6, h: 7}
  """
  def interpret(input) do
    Regex.named_captures(@regexp, input)
    |> Enum.map(fn {k,v}->{String.to_atom(k),String.to_integer(v)} end)
    |> Map.new
  end
  
  def build_pixels(%{id: id, x: x, y: y, w: w, h: h}) do
    for i <- (0..w-1), j <- (0..h-1),
      do: %{x: x + i, y: y + j} 
  end
  
  # We store all the "pixels" in a map to count them later
  def mark(box = %{id: id}, map) do
    build_pixels(box)
    |> Enum.reduce(map, fn(p, acc) -> 
      Map.put(acc, p, Map.get(acc, p, []) ++ [id])
    end)
  end

  # Input is analysed line by line, then we build a map of all the pixels
  # drawn by each box
  def build_map(input) do
    input
    |> String.splitter("\n", trim: true)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&(interpret(&1)))
  end
  
  def mark_map(map) do
    map
    |> Enum.reduce(Map.new, fn(p, acc) -> 
      mark(p, acc)
    end)
  end
  
  # here we finally we count all the pixels drawn more than once.
  def count_overlap(input) do
    input
    |> build_map
    |> mark_map
    |> Enum.reduce(0, fn({_, ids}, acc) ->
      if Enum.count(ids) > 1 do acc + 1 else acc end
    end)
  end
  
  def find_non_overlapping(input) do
    map = input
    |> build_map
    
    all_ids = Enum.reduce(map, MapSet.new, fn(p, acc) ->
      MapSet.put(acc, p.id)
    end)

    overlapping_ids = map
    |> mark_map
    |> Enum.filter(fn({_coords, ids}) -> Enum.count(ids) > 1 end)
    |> Enum.map((fn({_coords, ids}) -> ids end))
    |> List.flatten
    |> Enum.uniq

    MapSet.difference(all_ids, MapSet.new(overlapping_ids))
    |> Enum.to_list
  end
end