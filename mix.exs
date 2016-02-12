defmodule BrandoNews.Mixfile do
  use Mix.Project

  @version "0.1.0-dev"

  def project do
    [app: :brando_news,
     version: @version,
     compilers: [:gettext, :phoenix] ++ Mix.compilers,
     elixirc_paths: elixirc_paths(Mix.env),
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: applications(Mix.env)]
  end

  defp applications(:test), do: applications(:all) ++ [:ecto, :phoenix]
  defp applications(_all) do
    [:gettext, :logger]
  end

  defp deps do
    [{:phoenix, "~> 1.1"},
     {:gettext, "~> 0.9.0"},

     {:phoenix_ecto, "~> 2.0", only: :test},
     {:ex_machina, "~> 0.6.1", only: :test},

     {:brando, github: "twined/brando", optional: true}]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]
end
