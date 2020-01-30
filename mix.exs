defmodule Semtex.MixProject do
  use Mix.Project

  def project do
    [
      app: :semtex,
      version: "0.3.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      description: "Sanitize HTML",
      package: [
        licenses: ["MIT"],
        links: %{
          "GitHub" => "https://github.com/alizain/semtex"
        }
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
      {:html5ever, github: "rusterlium/html5ever_elixir", ref: "f6743865c353aaebaec1959ae4025596f8344587"},
      {:benchee, "~> 0.13", only: :dev},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
end
