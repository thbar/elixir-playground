defmodule Issues.CLI do
  def run(argv) do
    parse_args(argv)
  end

  def parse_args(args) do
    parse = OptionParser.parse(args, switches: [help: :boolean])
    case parse do
      { [ help: true], _, _ } -> :help
      _ -> :unknown
    end
  end
end
