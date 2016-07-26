defmodule Playground do
  use Mix.Project

  def project do
    [
      app: :playground,
      version: "1.0.0",
      deps: [
        {:apex, "~> 0.4.0", only: [:dev, :test]},
        {:dogma, "~> 0.0", only: :dev},
        {:mix_test_watch, "~> 0.2", only: :dev}
      ]
    ]
  end
end
