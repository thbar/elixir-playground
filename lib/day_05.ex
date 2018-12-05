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

defmodule Day0501Fast do
  def reacting_polymer?(<<u1>>, <<u2>>) do
    abs(u1 - u2) == (?a - ?A)
  end
  
  def react([], result) do
    result
  end

  def react([current], result) do
    result ++ [current]
  end

  def react([current | left = [next | sub_tail]], result) do
    if reacting_polymer?(current, next) do
      react(sub_tail, result)
    else
      result ++ [current] ++ react(left, result)
    end
  end

  def react_all(input) do
    new_result = react(input, [])
    if new_result == input do
      input |> Enum.join()
    else
      react_all(new_result)
    end
  end
  
  def solve_fast(input) do
    input 
    |> String.graphemes
    |> react_all
  end
end

defmodule Day0502 do

  def length_without(unit_type, input, fun) do
    IO.puts "Processing unit type #{unit_type}"
    input
    |> String.replace(<<unit_type>>, "")
    |> String.replace(<<unit_type + ?a - ?A>>, "")
    |> fun.()
    |> String.length
  end

  def solve(input, fun \\ &Day0502.length_without/1) do
    {_troubling_unit, shortest_polymer_size} = ?A..?Z
    |> Enum.map(&({&1, length_without(&1, input, fun)}))
    |> Map.new
    |> Enum.sort_by(fn({_,v}) -> v end)
    |> List.first
    
    shortest_polymer_size
  end
end