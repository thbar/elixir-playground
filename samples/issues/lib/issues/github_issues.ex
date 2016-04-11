defmodule Issues.GithubIssues do
  @user_agent [{"User-agent", "Elixir dave@pragprog.com"}]
  @moduledoc """
    A central place to query for Github issues
  """

  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end
  
  def issues_url(user, project) do
    "https://api.github.com/repos/#{user}/#{project}/issues"
  end

  # TODO: find a DRYer way to implement this.
  def handle_response({:ok, %{status_code: 200, body: body}}) do
    { :ok, body }
  end
  
  def handle_response({_, %{status_code: _, body: body}}) do
    { :error, body }
  end
  
end