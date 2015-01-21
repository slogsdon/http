defmodule Http.Mixfile do
  use Mix.Project

  def project do
    [app: :http,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps]
  end

  def application do
    [applications: [:logger, :ranch],
     mod: {Http, []}]
  end

  defp deps do
    [{:ranch, "~> 1.0.0"}]
  end
end
