defmodule GithubIssuesTest do
  use ExUnit.Case, async: false # false required due to mocking afaik
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  import Issues.GithubIssues, only: [ fetch: 2 ]

  test "reports :error when not found" do
    {:ok, body} = Poison.encode(%{"message" => "this"})
    use_cassette :stub, [
      url: "https://api.github.com/repos/thbar/unknown-project/issues", 
      body: body, 
      status_code: 404] do
      { :error, _output } = fetch("thbar", "unknown-project")
    end
  end
end