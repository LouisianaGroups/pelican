use Mix.Config

config :pelican, PelicanWeb.Endpoint,
  load_from_system_env: true,
  url: [scheme: "https", host: "pelican.freighter.cloud", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE")

config :logger, level: :info
