defmodule Issues.Mixfile do
  use Mix.Project

  def project do
    [app: :issues,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:dogma, "~> 0.1", only: :dev},
      {:credo, "~> 0.3", only: [:dev, :test]},
      {:mix_test_watch, "~> 0.2", only: :dev},
      {:httpoison, "~> 0.8.3"},
      {:poison, "~> 2.1"},
      {:apex, "~> 0.4.0", only: [:dev, :test]},
      {:exvcr, "~> 0.7", only: :test}
    ]
  end
end
