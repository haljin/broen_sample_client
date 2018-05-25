defmodule BroenSampleClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :broen_sample_client,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {BroenSampleClient.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:amqp_director, "~> 1.1"},
      {:poison, "~> 3.1"}
    ]
  end
end
