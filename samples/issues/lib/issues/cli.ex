defmodule Issues.CLI do
  @default_count 4

  @moduledoc """
  The CLI entry point for our app
  """

  def run(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean])
    case parse do
      { [ help: true], _, _ } -> :help
      _ -> :unknown
    end
  end

end
