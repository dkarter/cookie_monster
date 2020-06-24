defmodule CookieMonster.MixProject do
  use Mix.Project

  def project do
    [
      app: :cookie_monster,
      version: "0.1.0",
      elixir: "~> 1.10",
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
      {:dialyxir, "~> 1.0.0", runtime: false, only: [:test, :dev]},
      {:credo, "~> 1.4.0", runtime: false, only: [:test, :dev]}
    ]
  end
end
