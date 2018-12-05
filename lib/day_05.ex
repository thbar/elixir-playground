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
