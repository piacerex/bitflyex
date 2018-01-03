defmodule Bitflyex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :bitflyex,
      version: "0.0.3",
      elixir: "~> 1.5",
		description: "bitFlyer Lightning API libraries in Elixir", 
		package: 
		[
			maintainers: [ "data-maestro" ], 
			licenses:    [ "MIT" ], 
			links:       %{ "GitHub" => "https://github.com/data-maestro/bitflyex" }, 
		],
      start_permanent: Mix.env == :prod,
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
			{ :ex_doc,              "~> 0.18.1", only: :dev, runtime: false }, 
			{ :earmark,             "~> 1.2.4",  only: :dev }, 
			{ :power_assert,        "~> 0.1.1",  only: :test }, 
			{ :mix_test_watch,      "~> 0.5.0",  only: :dev, runtime: false }, 
			{ :dialyxir,            "~> 0.5.1",  only: :dev }, 

			{ :httpoison,           "~> 0.13.0" }, 
			{ :poison,              "~> 3.1.0" }, 
			{ :timex,               "~> 3.1.24" }, 
		]
	end
end
