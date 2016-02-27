defmodule Issues.GitHub do
  def fetch_issues(user, project) do
    issues_url(user, project)
    # TODO: add user agent, but verify and understand the data structure
    # passed as a parameter first
    |> HTTPoison.get
    |> handle_response
  end

  def issues_url(user, project) do
    "https://api.github.com/repos/#{user}/#{project}/issues"
  end

  # TODO: :ok is idiomatic here, but check in other implementations
  def handle_response({ :ok, %{status_code: 200, body: body}}) do
    Poison.Parser.parse(body)
  end

  def handle_response({ _, %{status_code: ___, body: body}}) do
    # TODO: handle Poison parsing error - this is not the right way to do it since it can fail
    { :error, Poison.Parser.parse(body) }
  end
end
