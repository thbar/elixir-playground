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

  test "compute solution for puzzle 03 " do
    assert 12 ==
             AdventOfCode2018.Puzzle02.solve(~S"""
               abcdef
               bababc
               abbcde
               abcccd
               aabcdd
               abcdee
               ababab
             """)

    input = File.read!("input/input-day-02.txt")
    assert 7872 == AdventOfCode2018.Puzzle02.solve(input)
  end

  test "jaro" do
    input = ~S"""
      abcde
      fghij
      klmno
      pqrst
      fguij
      axcye
      wvxyz
    """

    assert "fgij" == AdventOfCode2018.Puzzle04.find(input)

    input = File.read!("input/input-day-02.txt")
    assert "tjxmoewpdkyaihvrndfluwbzc" == AdventOfCode2018.Puzzle04.find(input)
  end

  doctest AdventOfCode2018.Day0301

  test "count_overlap" do
    input = """
      #1 @ 1,3: 4x4
      #2 @ 3,1: 4x4
      #3 @ 5,5: 2x2
    """

    assert 4 == AdventOfCode2018.Day0301.count_overlap(input)

    # Note: we could use stream here, but not necessary at this point
    # input = File.read!("input/input-day-3.txt")
    # assert "116489" == AdventOfCode2018.Day0301.count_overlap(input)
  end

  test "find_non_overlapping" do
    input = """
      #1 @ 1,3: 4x4
      #2 @ 3,1: 4x4
      #3 @ 5,5: 2x2
    """

    assert [3] == AdventOfCode2018.Day0301.find_non_overlapping(input)

    input = File.read!("input/input-day-3.txt")
    assert [1260] == AdventOfCode2018.Day0301.find_non_overlapping(input)
  end

  test "day 4 most minutes asleep" do
    winner = Day04.solve_day_4_puzzle_1("input/input-day-04-sample.txt")
    assert winner.guard_id * winner.most_slept_minute == 240

    winner = Day04.solve_day_4_puzzle_1("input/input-day-04.txt")
    assert winner.guard_id * winner.most_slept_minute == 39698

    assert 4455 = Day04.solve_day_4_puzzle_2("input/input-day-04-sample.txt")

    assert 14920 = Day04.solve_day_4_puzzle_2("input/input-day-04.txt")
  end
  
  test "day 5 puzzle 1" do
    assert Day0501.solve("dabAcCaCBAcCcaDA") == "dabCBAcaDA"
    assert 11242 == Day0501.solve(File.read!("input/input-day-05.txt")) |> String.trim |> String.length
  end

  @tag :skip # takes several minutes
  test "day 5 puzzle 2" do
    input = File.read!("input/input-day-05.txt") |> String.trim
    IO.puts Day0502.solve(input)
  end
end
