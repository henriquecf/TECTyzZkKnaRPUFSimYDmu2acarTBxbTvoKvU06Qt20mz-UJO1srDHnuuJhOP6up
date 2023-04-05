defmodule Askmybook.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      AskmybookWeb.Telemetry,
      # Start the Ecto repository
      Askmybook.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Askmybook.PubSub},
      # Start Finch
      {Finch, name: Askmybook.Finch},
      # Start the Elixir-NX server
      {Nx.Serving,
       serving: Askmybook.Model.serving([]),
       name: AskmybookModel,
       batch_size: 8,
       batch_timeout: 100},
      # Start the Index server
      Askmybook.Index,
      # Start the Endpoint (http/https)
      AskmybookWeb.Endpoint
      # Start a worker by calling: Askmybook.Worker.start_link(arg)
      # {Askmybook.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Askmybook.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AskmybookWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
