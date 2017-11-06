defmodule Playground do
  use Mix.Project

  def project do
    [
      app: :playground,
      version: "1.0.0",
      deps: [
        {:apex, "~> 1.1.0", only: [:dev, :test]},
        {:dogma, "~> 0.1.15", only: :dev},
        {:mix_test_watch, "~> 0.5", only: :dev}
      ]
    ]
  end
end
