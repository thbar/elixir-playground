defmodule Issues.GitHub do
  def fetch_issues(user, project) do
    url = "https://api.github.com/repos/#{user}/#{project}/issues"
    # TODO: add user agent, but verify and understand the data structure
    # passed as a parameter first
    response = HTTPoison.get(url)
    handle_response(response)
  end

  def handle_response({ :ok, %{status_code: 200, body: body}}) do
    IO.puts body
  end
end
