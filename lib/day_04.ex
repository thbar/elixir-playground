defmodule Day04 do
  # Use atoms for keys + use nil rather than blank string
  def clean_input_map(map) do
    Map.new(map, fn {k, v} ->
      {
        k |> String.to_atom(),
        if v == "" do
          nil
        else
          v
        end
      }
    end)
  end

  def build_day_4_puzzle_1_data(filename) do
    regexp = ~r/^\[(?<ts>(.*))\]( Guard #(?<guard_id>\d+))? (?<event>.*)$/

    # NOTE: using stream but ultimately the sorting requires everything in memory
    guards_data =
      File.stream!(filename)
      |> Stream.map(&String.trim/1)
      # NOTE: lexicographical sort equals time sort in this case
      |> Enum.sort()
      |> Stream.map(&Regex.named_captures(regexp, &1))
      |> Stream.map(&clean_input_map/1)
      |> Stream.transform(nil, fn item, acc ->
        new_id = item.guard_id || acc

        {
          [Map.put(item, :guard_id, String.to_integer(new_id))],
          new_id
        }
      end)
      |> Enum.group_by(& &1.guard_id)
      |> Enum.map(fn {guard_id, events} ->
        sleep_ranges =
          events
          |> Enum.filter(&(&1.event == "falls asleep" or &1.event == "wakes up"))
          |> Enum.map(&(DateTime.from_iso8601(&1.ts <> ":00Z") |> elem(1)))
          |> Enum.chunk_every(2)

        sleep_time =
          sleep_ranges
          |> Enum.map(fn [sleeps, wakes_up] ->
            DateTime.diff(wakes_up, sleeps, :second) / 60
          end)
          |> Enum.sum()

        m =
          sleep_ranges
          |> Enum.map(fn [s, e] -> s.minute..(e.minute - 1) end)
          |> Enum.map(&Enum.to_list/1)
          |> List.flatten()
          |> Enum.group_by(& &1)
          |> Enum.map(fn {x, y} -> %{minute: x, count: Enum.count(y)} end)
          |> Enum.sort_by(fn i -> i.count end)
          |> List.last()

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
    |> Enum.sort_by(fn %{sleep_time: s} -> s end)
    |> List.last()
  end

  def solve_day_4_puzzle_2(filename) do
    guard =
      build_day_4_puzzle_1_data(filename)
      |> Enum.sort_by(fn %{most_slept_minute_count: c} -> c end)
      |> List.last()

    guard.guard_id * guard.most_slept_minute
  end
end