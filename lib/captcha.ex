defmodule AdventOfCode2017.Captcha do
  @doc ~S"""
  The captcha requires you to review a sequence of digits (your puzzle input) and
  find the sum of all digits that match the next digit in the list. The list is circular,
  so the digit after the last digit is the first digit in the list.

  ## Examples

      iex> AdventOfCode2017.Captcha.solve("1122")
      3
      iex> AdventOfCode2017.Captcha.solve("1111")
      4
      iex> AdventOfCode2017.Captcha.solve("1234")
      0
      iex> AdventOfCode2017.Captcha.solve("91212129")
      9
      iex> AdventOfCode2017.Captcha.solve("")
      0
      # This spec depends on how you interpret the request
      iex> AdventOfCode2017.Captcha.solve("1")
      1
  """
  def solve(input) do
    digits = input |> String.graphemes() |> Enum.map(&String.to_integer/1)
    # cycle the digits to the left
    next_digits = Enum.take(digits, -(Enum.count(digits) - 1)) ++ Enum.take(digits, 1)

    digits
    |> Enum.zip(next_digits)
    |> Enum.reduce(0, fn {digit, next_digit}, acc ->
      if digit == next_digit do
        acc + digit
      else
        acc
      end
    end)
  end
end
