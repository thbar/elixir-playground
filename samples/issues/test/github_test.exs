defmodule GitHubTest do
  use ExUnit.Case, async: false # false required due to mocking afaik
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney


  test "fetches data" do
    import Issues.GitHub, only: [ fetch_issues: 2]

    Apex.ap fetch_issues("thbar", "kiba")
  end
end
