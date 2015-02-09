defmodule Http.Mixfile do
  use Mix.Project

  def project do
    [ app: :http,
      version: "0.0.2-dev",
      elixir: "~> 1.0",
      name: "Http",
      source_url: "https://github.com/slogsdon/http",
      deps: deps,
      description: description,
      package: package,
      docs: [ readme: "README.md", main: "README" ],
      test_coverage: [ tool: ExCoveralls ] ]
  end

  def application do
    [ applications: [ :logger, :pool, :crypto,
                      :public_key, :ssl ],
      mod: { Http, [] } ]
  end

  defp deps do
    [ { :pool, "~> 0.0.2" },
      { :earmark, "~> 0.1.12", only: :docs },
      { :ex_doc, "~> 0.6.2", only: :docs },
      { :excoveralls, "~> 0.3", only: :test },
      { :dialyze, "~> 0.1.3", only: :test } ]
  end

  defp description do
    """
    HTTP server for Elixir

    Not currently working, but close :)
    """
  end

  defp package do
    %{ contributors: [ "Shane Logsdon" ],
       licenses: [ "MIT" ],
       links: %{ "GitHub" => "https://github.com/slogsdon/http" } }
  end
end
