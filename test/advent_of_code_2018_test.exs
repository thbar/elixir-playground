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
  
  # Use atoms for keys + use nil rather than blank string
  def clean_input_map(map) do
    Map.new(map, fn({k, v}) -> 
      {
        k |> String.to_atom,
        if v == "" do nil else v end
      }
    end)
  end
  
  def build_day_4_puzzle_1_data(filename) do
    regexp = ~r/^\[(?<ts>(.*))\]( Guard #(?<guard_id>\d+))? (?<event>.*)$/
    
    # NOTE: using stream but ultimately the sorting requires everything in memory
    guards_data = File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Enum.sort # NOTE: lexicographical sort equals time sort in this case
    |> Stream.map(&(Regex.named_captures(regexp, &1)))
    |> Stream.map(&clean_input_map/1)
    |> Stream.transform(nil, fn(item, acc) ->
      new_id = item.guard_id || acc
      {
        [Map.put(item, :guard_id, String.to_integer(new_id))],
        new_id
      }
    end)
    |> Enum.group_by(&(&1.guard_id))
    |> Enum.map(fn({guard_id, events}) ->
      sleep_ranges = events
        |> Enum.filter(&(&1.event == "falls asleep" or &1.event == "wakes up"))
        |> Enum.map(&(DateTime.from_iso8601(&1.ts <> ":00Z") |> elem(1)))
        |> Enum.chunk_every(2)

      sleep_time = sleep_ranges
      |> Enum.map(fn([sleeps, wakes_up]) ->
        (DateTime.diff(wakes_up, sleeps, :second) / 60)
      end)
      |> Enum.sum

      m = sleep_ranges
      |> Enum.map(fn([s,e]) -> (s.minute..e.minute-1) end)
      |> Enum.map(&Enum.to_list/1)
      |> List.flatten
      |> Enum.group_by(&(&1))
      |> Enum.map(fn({x,y}) -> %{minute: x, count: Enum.count(y)} end)
      |> Enum.sort_by(fn(i) -> i.count end)
      |> List.last
      
      m = m || %{minute: nil, count: 0}

      %{
        guard_id: guard_id,
        sleep_time: sleep_time,
        most_slept_minute: m.minute,
        most_slept_minute_count: m.count
      }
    end)
  end

  def solve_day_4_puzzle_1(filename) do
    build_day_4_puzzle_1_data(filename)
      |> Enum.sort_by(fn(%{sleep_time: s}) -> s end)
      |> List.last
  end
  
  def solve_day_4_puzzle_2(filename) do
    guard = build_day_4_puzzle_1_data(filename)
    |> Enum.sort_by(fn(%{most_slept_minute_count: c}) -> c end)
    |> List.last
    
    guard.guard_id * guard.most_slept_minute
  end
  
  test "day 4 most minutes asleep" do
    winner = solve_day_4_puzzle_1("input/input-day-04-sample.txt")
    assert winner.guard_id * winner.most_slept_minute == 240
    
    winner = solve_day_4_puzzle_1("input/input-day-04.txt")
    assert winner.guard_id * winner.most_slept_minute == 39698
    
    assert 4455 = solve_day_4_puzzle_2("input/input-day-04-sample.txt")
    
    assert 14920 = solve_day_4_puzzle_2("input/input-day-04.txt")
  end
end
