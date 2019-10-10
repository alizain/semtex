defmodule Semtex.MixProject do
  use Mix.Project

  def project do
    [
      app: :semtex,
      version: "0.2.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps()
    ]
  end

  defp elixirc_paths(:test), do: elixirc_paths() ++ ["test/support"]
  defp elixirc_paths(_), do: elixirc_paths()
  defp elixirc_paths(), do: ["lib"]

  def application do
    []
  end

  defp deps do
    [
      {:html5ever, "~> 0.7.0", only: [:dev, :test]},
      {:myhtmlex, "~> 0.2.0", only: [:dev, :test]},
      {:benchee, "~> 0.13", only: [:dev, :test]},
    ]
  end
end
