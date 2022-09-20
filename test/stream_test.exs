defmodule StreamTest do
  use ExUnit.Case, async: true

  test "range is a stream" do
    range = 1..3
    stream = Stream.map(range, &(&1 * 10))
    assert [10, 20, 30] == Enum.into(stream, [])
    # there is no state in there
    assert [20, 30] == Enum.into(stream |> Stream.drop(1), [])
    assert [20] == Enum.into(stream |> Stream.drop(1) |> Stream.take(1), [])
  end

  test "URI.query_decoder returns a stream" do
    stream = URI.query_decoder("foo=1&bar=2")
    assert stream |> Stream.take(1) |> Enum.to_list() == [{"foo", "1"}]
    assert stream |> Stream.drop(1) |> Stream.take(1) |> Enum.to_list() == [{"bar", "2"}]
  end

  test "chunk_by/2" do
    # there is no range based on graphemes directly,
    # so I iterate on codepoints & conver to UTF-8
    # for later chunking. alternatively we could work
    # with
    digits = for x <- ?0..?9, do: <<x::utf8>>

    # here we'll group by chunks of digits vs. non digits
    result =
      "ab12k6b1"
      # NOTE: String.graphemes is not streaming!
      |> String.graphemes()
      |> Stream.chunk_by(&(&1 in digits))
      |> Enum.to_list()

    assert result == [["a", "b"], ["1", "2"], ["k"], ["6"], ["b"], ["1"]]
  end

  test "chunk_by/4 (no step)" do
    result =
      "FR76AB47PA26"
      |> String.graphemes()
      |> Stream.chunk_every(4)
      |> Enum.map(&Enum.join(&1))
      |> Enum.to_list()

    assert result == ["FR76", "AB47", "PA26"]
  end

  test "chunk_by/4 (with step and discard)" do
    result =
      "ABCDEF"
      |> String.graphemes()
      |> Stream.chunk_every(3, 2, :discard)
      |> Enum.map(&Enum.join(&1))
      |> Enum.to_list()

    assert result == ["ABC", "CDE"]
  end

  @tag :skip
  test "chunk_while"

  test "concat" do
    [1..2, 3..4, 5..6]
    |> Stream.concat()
    |> Enum.to_list()
    |> (&assert(&1 == [1, 2, 3, 4, 5, 6])).()
  end

  test "drop_while" do
    [1..10, 1..5]
    |> Stream.concat()
    |> Stream.drop_while(&(&1 <= 5))
    |> Enum.to_list()
    |> (&assert(&1 == [6, 7, 8, 9, 10, 1, 2, 3, 4, 5])).()
  end

  test "flat_map" do
    # useful, for instance, to generate N output items for each input item
    1..2
    |> Stream.flat_map(&[&1, 100 + &1])
    |> Enum.to_list()
    |> (&assert(&1 == [1, 101, 2, 102])).()
  end

  test "intersperse" do
    "FR76AB38XY12"
    |> String.graphemes()
    |> Stream.chunk_every(4)
    |> Stream.map(&Enum.join(&1))
    |> Stream.intersperse("-")
    |> Enum.to_list()
    |> (&assert(&1 == ["FR76", "-", "AB38", "-", "XY12"])).()
  end

  test "scan for tortuous one-pass CSV generation with first row keys as mandatory headers" do
    fetch_values_in_order = fn row, headers ->
      for h <- headers, do: Map.fetch!(row, h)
    end

    [
      %{id: 1, name: "John"},
      %{id: 2, name: "Mary"}
    ]
    |> Stream.scan(nil, fn
      e, nil ->
        headers = Map.keys(e)
        {headers, [headers, fetch_values_in_order.(e, headers)]}

      e, {headers, _} ->
        {headers, [fetch_values_in_order.(e, headers)]}
    end)
    |> Stream.flat_map(fn {_h, rows} -> rows end)
    |> Enum.to_list()
    |> (&assert(&1 == [[:id, :name], [1, "John"], [2, "Mary"]])).()
  end

  test "scan for much less tortuous CSV generation (with explicit headers)" do
    fetch_values_in_order = fn row, headers ->
      for h <- headers, do: Map.fetch!(row, h)
    end

    # this time, instead of inferring headers based on first row,
    # we prefer to use something explicit.
    headers = [:id, :name]

    rows =
      [
        %{id: 1, name: "John"},
        %{id: 2, name: "Mary"}
      ]
      |> Stream.map(fn row -> fetch_values_in_order.(row, headers) end)

    [headers]
    |> Stream.concat(rows)
    |> Enum.to_list()
    |> (&assert(&1 == [[:id, :name], [1, "John"], [2, "Mary"]])).()
  end
end
