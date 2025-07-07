defmodule PeriodTracker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PeriodTrackerWeb.Telemetry,
      PeriodTracker.Repo,
      {DNSCluster, query: Application.get_env(:period_tracker, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PeriodTracker.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PeriodTracker.Finch},
      # Start a worker by calling: PeriodTracker.Worker.start_link(arg)
      # {PeriodTracker.Worker, arg},
      # Start to serve requests, typically the last entry
      PeriodTrackerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PeriodTracker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PeriodTrackerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
