defmodule CookieMonster.MixProject do
  use Mix.Project

  def project do
    [
      app: :cookie_monster,
      version: "0.1.1",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: dialyzer(),

      # Docs
      name: "CookieMonster",
      source_url: "https://github.com/dkarter/cookie_monster",
      docs: [
        main: "CookieMonster",
        extras: ["README.md"]
      ],

      # Hex PM
      description: description(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp dialyzer do
    [
      plt_core_path: "priv/plts",
      plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
    ]
  end

  defp description do
    "A simple HTTP Cookie encoder and decoder in pure Elixir with zero runtime dependencies."
  end

  defp package do
    [
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/dkarter/cookie_monster"}
    ]
  end

  defp deps do
    [
      {:dialyxir, "~> 1.0.0", runtime: false, only: [:test, :dev]},
      {:credo, "~> 1.4.0", runtime: false, only: [:test, :dev]},
      {:ex_doc, "~> 0.22", runtime: false, only: :dev}
    ]
  end
end
