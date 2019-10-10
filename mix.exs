defmodule Semtex.MixProject do
  use Mix.Project

  def project do
    [
      app: :semtex,
      version: "0.2.0",
      # Try with Elixir 1.6
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      description: "Sanitize HTML",
      package: [
        licenses: "MIT",
        links: [
          "https://github.com/alizain/semtex"
        ]
      ]
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
      {:benchee, "~> 0.13", only: :dev},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
end
