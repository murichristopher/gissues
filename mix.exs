defmodule Gissues.MixProject do
  use Mix.Project

  def project do
    [
      app: :gissues,
      version: "0.1.0",
      escript: escript_config(),
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.0.0"},
      {:poison, "~> 3.1"},
      {:tabula, "~> 2.2.4"},
      {:mox, "~> 0.5.2", only: :test}
    ]
  end

  defp escript_config do
    [
      main_module: Gissues.CLI
    ]
  end
end
