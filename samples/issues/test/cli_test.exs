defmodule CLITest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [
    parse_args: 1,
    sort_into_ascending_order: 1,
    convert_to_list_of_maps: 1
  ]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
  end
  
  test "three values returned if three given" do
    assert parse_args(["user", "project", "16"]) == {"user", "project", 16}
  end
  
  test "count is defaulted if two values given" do
    assert parse_args(["user", "project"]) == {"user", "project", 4}
  end
  
  test "sort ascending orders the correct way" do
    result = sort_into_ascending_order(fake_created_at_list(["c", "a", "b"]))
    issues = for issue <- result, do: issue["created_at"]
    assert issues == ~w{a b c}
  end
  
  @tag :pending
  test "exercice: OrganizingAProject-4" do
    IO.puts """
    (Tricky) Before reading the next section, see if you can write the code to
    format the data into columns, like the sample output at the start of the
    chapter. This is probably the longest piece of Elixir code you’ll have
    written. Try to do it without using if or cond.
    
     #  | created_at           | title
    ----+----------------------+-----------------------------------------
    889 | 2013-03-16T22:03:13Z | MIX_PATH environment variable (of sorts)
    892 | 2013-03-20T19:22:07Z | Enhanced mix test --cover
    893 | 2013-03-21T06:23:00Z | mix test time reports
    898 | 2013-03-23T19:19:08Z | Add mix compile --warnings-as-errors
    """
  end
  
  defp fake_created_at_list(values) do
    data = for value <- values,
      do: [{"created_at", value}, {"other_data", "xxx"} ]
    convert_to_list_of_maps data
  end
end
