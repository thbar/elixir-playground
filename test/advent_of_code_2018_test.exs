Code.require_file("test/test_helper.exs")

defmodule AdventOfCode2018Test do
  use ExUnit.Case, async: true
  doctest AdventOfCode2018.Puzzle01

  test "compute solution for puzzle 01 " do
    questions = File.read!("input/my-input.txt")
    IO.inspect(AdventOfCode2018.Puzzle01.solve(questions))
  end

  test "compute solution for puzzle 02 " do
    questions = File.read!("input/my-input.txt")
    IO.inspect(AdventOfCode2018.Puzzle01.solve_repeat(questions))
  end
end
