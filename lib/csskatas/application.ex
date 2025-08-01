defmodule CSSKatas.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    :ok = OpentelemetryPhoenix.setup()
    :ok = OpentelemetryLiveView.setup()

    children = [
      # Start the Telemetry supervisor
      CSSKatasWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: CSSKatas.PubSub},
      # Start the Endpoint (http/https)
      CSSKatasWeb.Endpoint
      # Start a worker by calling: CSSKatas.Worker.start_link(arg)
      # {CSSKatas.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CSSKatas.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CSSKatasWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
