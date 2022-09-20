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

  @tag :focus
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
end
