use Mix.Config

config :pelican, PelicanWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "C8L8pe5U0j21E0RLce3bzvbgiDUnq0Uxbc/azRqWyW9ekWgpaqHty3WwkOP3zfJG",
  render_errors: [view: PelicanWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Pelican.PubSub, adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :pelican, Pelican.GSX, client: Pelican.GSX.HTTPClient

import_config "#{Mix.env()}.exs"
