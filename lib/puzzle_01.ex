defmodule AdventOfCode2018.Puzzle01 do
  @doc ~S"""
    Examples:

    iex> AdventOfCode2018.Puzzle01.solve("+1\n+3")
    4
    iex> AdventOfCode2018.Puzzle01.solve("-3\n+2")
    -1
  """
  def solve(text_input) do
    text_input
    |> String.trim_trailing()
    |> String.split("\n")
    |> Enum.map(&String.to_integer(&1))
    |> Enum.reduce(0, &(&1 + &2))
  end

  @doc ~S"""
    Examples:
    
    iex> AdventOfCode2018.Puzzle01.solve_repeat("+1\n-1")
    0
    iex> AdventOfCode2018.Puzzle01.solve_repeat("+3\n+3\n+4\n-2\n-4\n")
    10
  """
  def solve_repeat(text_input) do
    text_input
    |> String.trim_trailing()
    |> String.split("\n")
    |> Enum.map(&String.to_integer(&1))
    |> AdventOfCode2018.Puzzle01.find_repeat()
  end

  def find_repeat([change | changes], frequency \\ 0, already_seen \\ MapSet.new([0])) do
    frequency = frequency + change

    if MapSet.member?(already_seen, frequency) do
      frequency
    else
      set = MapSet.put(already_seen, frequency)
      find_repeat(changes ++ [change], frequency, set)
    end
  end
end
