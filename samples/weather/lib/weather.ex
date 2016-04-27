defmodule Weather do
  defmodule CLI do
    def main(args) do
      process(args)
    end

    def process([target_code]) do
      target_code
      |> build_url
      |> fetch_page
      |> parse_response
      |> IO.puts
    end

    def process(_) do
      IO.puts "Syntax: weather target_code (e.g. KDTO)"
      System.halt(-1)
    end

    @doc """
    Build the URL from where to fetch weather data.

    ## Examples

        iex> Weather.CLI.build_url("FOOBAR")
        "http://w1.weather.gov/xml/current_obs/FOOBAR.xml"
    """
    def build_url(code) do
      "http://w1.weather.gov/xml/current_obs/#{code}.xml"
    end

    @doc """
    Fetch the URL content
    """
    def fetch_page(url) do
      HTTPoison.get!(url)
    end

    def parse_response(response) do
      response.body
    end
  end
end
