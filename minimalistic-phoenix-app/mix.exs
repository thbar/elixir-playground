defmodule MyMixfile do
  use Mix.Project

  def project do
    [app: :my_application,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: ["lib"],
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: [
       {:phoenix, "~> 1.1.4"},
       {:cowboy, "~> 1.0"}]
     ]
  end

  def application do
    [mod: {MyApplication, []},
    # I tried to remove :logger but I get an exception
     applications: [:phoenix, :cowboy, :logger]]
  end
end
