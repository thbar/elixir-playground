defmodule GitHubTest do
  use ExUnit.Case

  test "fetches data" do
    import Issues.GitHub, only: [ fetch_issues: 2]

    fetch_issues("thbar", "kiba")
  end
end
