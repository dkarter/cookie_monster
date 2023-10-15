defmodule CookieMonster.MixProject do
  use Mix.Project

  @version "1.1.2"

  def project do
    [
      app: :cookie_monster,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: dialyzer(),

      # Boundary compile time checks
      boundary: [
        default: [
          type: :strict,
          check: [
            apps: [:logger]
          ]
        ]
      ],
      compilers: [:boundary] ++ Mix.compilers(),

      # Docs
      name: "CookieMonster",
      source_url: "https://github.com/dkarter/cookie_monster",
      docs: [
        main: "CookieMonster",
        extras: ["README.md", "CHANGELOG.md"]
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
      {:boundary, "~> 0.10", runtime: false},
      {:credo, "~> 1.7", runtime: false, only: [:test, :dev]},
      {:dialyxir, "~> 1.4", runtime: false, only: [:test, :dev]},
      {:ex_doc, "~> 0.30", runtime: false, only: :dev}
    ]
  end
end
