defmodule Issues.GithubIssues do
  @user_agent [{"User-agent", "Elixir dave@pragprog.com"}]
  @moduledoc """
    A central place to query for Github issues
  """

  def fetch(user, project) do
    issues_url(user, project)
      |> HTTPoison.get(@user_agent)
  end
  
  def issues_url(user, project) do
    "https://api.github.com/repos/#{user}/#{project}/issues"
  end
  
end