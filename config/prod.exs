use Mix.Config

config :pelican, PelicanWeb.Endpoint,
  load_from_system_env: true,
  url: [host: "gsx.freighter.cloud", port: 80],
  secret_key_base: Map.fetch!System.get_env(), "SECRET_KEY_BASE")

config :logger, level: :info
