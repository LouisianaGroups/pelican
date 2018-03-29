defmodule Pelican.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(PelicanWeb.Endpoint, []),
      worker(Pelican.Worker, ["12zkNdCEEyFeUlIj7Lw_v5-krx3YRws1olJ12N0e8XSU"]),
    ]

    opts = [strategy: :one_for_one, name: Pelican.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    PelicanWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
