defmodule Http.Mixfile do
  use Mix.Project

  def project do
    [ app: :http,
      version: "0.0.1",
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
      { :earmark, "~> 0.1.12" },
      { :ex_doc, "~> 0.6.2" },
      { :excoveralls, "~> 0.3" },
      { :dialyze, "~> 0.1.3" } ]
  end

  defp description do
    """
    HTTP server for Elixir
    """
  end

  defp package do
    %{ contributors: [ "Shane Logsdon" ],
       licenses: [ "MIT" ],
       links: %{ "GitHub" => "https://github.com/slogsdon/http" } }
  end
end
