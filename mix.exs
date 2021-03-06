defmodule HelloNerves.Mixfile do
  use Mix.Project

  @target System.get_env("MIX_TARGET") || "host"
  Mix.shell.info([:green, """
  Env
    MIX_TARGET:   #{@target}
    MIX_ENV:      #{Mix.env}
  """, :reset])
  def project do
    [app: :hello_nerves,
     version: "0.1.0",
     elixir: "~> 1.4.0",
     target: @target,
     archives: [nerves_bootstrap: "~> 0.3.0"],
     kernel_modules: kernel_modules(@target),
     deps_path: "deps/#{@target}",
     build_path: "_build/#{@target}",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(@target),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application, do: application(@target)

  # Specify target specific application configurations
  # It is common that the application start function will start and supervise
  # applications which could cause the host to fail. Because of this, we only
  # invoke HelloNerves.start/2 when running on a target.
  def application("host") do
    [extra_applications: [:logger]]
  end
  def application(_target) do
    [mod: {HelloNerves.Application, []},
     extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  def deps do
    [{:nerves, "~> 0.5.0", runtime: false}] ++
    deps(@target)
  end

  # Specify target specific dependencies
  def deps("host"), do: []
  def deps(target) do
    [
      {:nerves_runtime, "~> 0.1.0"},
      {:"nerves_system_#{target}", "~> 0.11.0", runtime: false},
      {:elixir_ale, "~> 0.5.7"},
      {:nerves_interim_wifi, "~> 0.2.0"},
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.0"},
      {:extwitter, "~> 0.8"},
      {:httpoison, "~> 0.11"},
      # Why must I specify these?
      {:oauther, "~> 1.1.0"},
      {:poison, "~> 2.2.0"},
    ]
  end

  def kernel_modules("rpi3"), do: ["brcmfmac"]
  def kernel_modules("rpi2"), do: ["8192cu"]
  def kernel_modules("rpi"), do: ["8192cu"]
  def kernel_modules(_), do: []

  # We do not invoke the Nerves Env when running on the Host
  def aliases("host"), do: []
  def aliases(_target) do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end

end
