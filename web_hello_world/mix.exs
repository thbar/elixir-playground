defmodule MyMixfile do
  use Mix.Project

  def project do
    [app: :my_application,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {MyApplication, []},
    # I tried to remove :logger but I get an exception
     applications: [:phoenix, :cowboy, :logger]]
  end

  # Specifies which paths to compile
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.1.4"},
     {:cowboy, "~> 1.0"}]
  end
end
