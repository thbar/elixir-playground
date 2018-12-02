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
    assert 12 == AdventOfCode2018.Puzzle02.solve(~S"""
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
end
