defmodule Http.Mixfile do
  use Mix.Project

  def project do
    [app: :http,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps]
  end

  def application do
    [applications: [:logger, :pool, :crypto, :public_key, :ssl],
     mod: {Http, []}]
  end

  defp deps do
    [{:pool, "~> 0.0.2"}]
  end
end
