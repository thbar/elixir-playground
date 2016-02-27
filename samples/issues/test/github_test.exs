defmodule GitHubTest do
  use ExUnit.Case, async: false # false required due to mocking afaik
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  import Issues.GitHub, only: [ fetch_issues: 2]

  test "fetches data" do
  end

  test "report error when not found" do
    # TODO: encode using Poison or similar
    body = "{ \"message\": \"this\" }"
    use_cassette :stub, [url: "https://api.github.com/repos/thbar/unknown-project/issues", body: body, status_code: 404] do
      # verify output of our library
      {:error, _output } = fetch_issues("thbar", "unknown-project")
      # but so far we can still have a parsing error - TODO: improve this
      _output = { :ok, %{message: "this" } }
    end
  end
end
