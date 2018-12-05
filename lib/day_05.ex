defmodule Day0501 do
  # slow version (~13 seconds on my laptop), using
  # a regexp
  def build_regexp() do
    ?A..?Z
    |> Enum.map(&(<<&1, &1 + ?a - ?A>>))
    |> Enum.map(&([&1, String.reverse(&1)]))
    |> List.flatten
    |> Enum.map(&("(#{&1})"))
    |> Enum.join("|")
    |> Regex.compile!
  end

  def solve(input, regexp \\ build_regexp()) do
    output = String.replace(input, regexp, "")
    cond do
      output == input -> output
      true -> solve(output, regexp)
    end
  end
end

defmodule Day0502 do

  def length_without(unit_type, input) do
    IO.puts "Processing unit type #{unit_type}"
    polymer = input
    |> String.replace(<<unit_type>>, "")
    |> String.replace(<<unit_type + ?a - ?A>>, "")
    |> Day0501.solve()
    |> String.length
  end

  def solve(input) do
    {_troubling_unit, shortest_polymer_size} = ?A..?Z
    |> Enum.map(&({&1, length_without(&1, input)}))
    |> Map.new
    |> Enum.sort_by(fn({k,v}) -> v end)
    |> List.first
    
    shortest_polymer_size
  end
end